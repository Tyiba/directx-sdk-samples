//--------------------------------------------------------------------------------------
// File: Tutorial06.fx
//
// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License (MIT).
//--------------------------------------------------------------------------------------


//--------------------------------------------------------------------------------------
// Constant Buffer Variables
//--------------------------------------------------------------------------------------
cbuffer ConstantBuffer : register(b0)
{
    matrix World;
    matrix View;
    matrix Projection;
    float4 vLightPos;
    float4 cameraPos;
    float4 materialAmb;
    float4 materialDiff;
    float4 materialSpec;
    
};

Texture2D txWoodColor : register( t0 );
SamplerState samLinear : register( s0 );

Texture2D txTileColor : register( t1 );
SamplerState samLinear2 : register( s1 );


//--------------------------------------------------------------------------------------
struct VS_INPUT
{
    float4 Pos : POSITION;
    float3 Norm : NORMAL;
    float2 Tex : TEXCOORD;

};

struct PS_INPUT
{
    float4 Pos : SV_POSITION;
    float3 Norm : TEXCOORD0;
	float3 worldPos : TEXCOORD1;
    float2 Tex : TEXCOORD2;
   

};

static const float4 lightCol = float4(1.0, 1.0, 1.0, 1.0);

//--------------------------------------------------------------------------------------
// Vertex Shader
//--------------------------------------------------------------------------------------
PS_INPUT VS( VS_INPUT input )
{
    PS_INPUT output = (PS_INPUT)0;
    
    output.Pos = mul( input.Pos, World );
    output.worldPos = output.Pos.xyz;
    output.Pos = mul( output.Pos, View);
    output.Pos = mul( output.Pos, Projection );
    output.Norm = mul(input.Norm, (float3x3)World);
	output.Tex = input.Tex;

    return output;
}

//--------------------------------------------------------------------------------------
// Pixel Shader
//--------------------------------------------------------------------------------------
float4 PS( PS_INPUT input) : SV_Target
{
    // Per Pixel Lighting
    float3 normal = normalize(input.Norm);
    float3 lightDir = normalize(vLightPos.xyz - input.worldPos.xyz);
	float3 viewDir = normalize(cameraPos.xyz - input.worldPos.xyz);

    //reflection
    // R = 2 * (N.L) * N - L
    //float3 reflectDir = 2 * dot(normal, lightDir) * normal - lightDir;
    //float3 reflectDir = reflect(-lightDir, normal);
    ////this is the same as the above line
    /// (reflect is a built-in function in hlsl that does the above calculation for you)
	float3 reflectDir = reflect(-lightDir, normal);

    //diffuse
    float diff = max(dot(normal, lightDir), 0.0f);

    //specular
    float spec = pow(max(dot(reflectDir, viewDir), 0.0f), 32.0f); //32 is the shininess factor

    // combine
    float4 ambient = materialAmb;
	float4 diffuse = diff * materialDiff * lightCol;
	float4 specular = materialSpec * lightCol * spec; //assuming white specular
    float4 woodColor = txWoodColor.Sample(samLinear, input.Tex);
    float4 tileColor = txTileColor.Sample(samLinear2, input.Tex);

    // Determine the final color based on the distance from the center
    float2 center = float2(0.5, 0.5); // Assuming the center is at (0.5, 0.5)
    float radius = 0.5; // Adjust the radius as needed
    float distance = length(input.Tex - center);

    float4 finalColor;
    if (distance < radius)
    {
        finalColor = txWoodColor.Sample(samLinear, input.Tex);
    }
    else
    {
        finalColor = txTileColor.Sample(samLinear2, input.Tex);
    }

// Apply lighting
    float4 light = (ambient + diffuse + specular);
    float4 color = finalColor * light;

    return color;
}

