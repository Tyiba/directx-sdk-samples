//--------------------------------------------------------------------------------------
// File: Tutorial07.fx
//
// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License (MIT).
//--------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------
// Constant Buffer Variables
//--------------------------------------------------------------------------------------
Texture2D txDiffuse : register( t0 );
SamplerState samLinear : register( s0 );

cbuffer cbNeverChanges : register( b0 )
{
    matrix View;
};

cbuffer cbChangeOnResize : register( b1 )
{
    matrix Projection;
};

cbuffer cbChangesEveryFrame : register( b2 )
{
    matrix World;
    float4 vMeshColor;
};


//--------------------------------------------------------------------------------------
struct VS_INPUT
{
    float4 Pos : POSITION;
    float3 Norm : NORMAL;
    float2 Tex : TEXCOORD0;
};

struct PS_INPUT
{
    float4 Pos : SV_POSITION;
    float3 Norm : TEXCOORD0;
    float2 Tex : TEXCOORD0;
};


//--------------------------------------------------------------------------------------
// Vertex Shader
//--------------------------------------------------------------------------------------
PS_INPUT VS( VS_INPUT input )
{
    PS_INPUT output = (PS_INPUT)0;
    output.Pos = mul( input.Pos, World );
    output.Pos = mul( output.Pos, View );
    output.Pos = mul( output.Pos, Projection );

    output.Norm = mul( input.Norm, World );
    output.Norm = mul( output.Norm, View );
    output.Norm = mul( output.Norm, Projection );
    output.Norm = normalize( output.Norm );

    output.Tex = input.Tex;
    
    return output;
}


//--------------------------------------------------------------------------------------
// Pixel Shader
//--------------------------------------------------------------------------------------
float4 PS( PS_INPUT input) : SV_Target
{
    float4 ambient = { 0.1, 0.0, 0.0, 1.0 };
    float4 lightColor = { 1.0f, 1.0f, 1.0f, 1.0f };

    float3 lightPosition = (1.0f, 1.0f, 0.0f);
    float3 lightDirection = normalize(lightPosition - input.Pos);

    float1 diffuse = saturate(dot(lightDirection, input.Norm)) * lightColor;

   float4 color = diffuse;

    //float4 solidColor = float4( 1.0f, 1.0f, 0.0f, 1.0f );
    //output.color = solidColor;
    return color;
}
