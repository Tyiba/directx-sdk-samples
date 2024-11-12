//--------------------------------------------------------------------------------------
// File: Tutorial04.fx
//
// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License (MIT).
//--------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------
// Constant Buffer Variables
//--------------------------------------------------------------------------------------
cbuffer ConstantBuffer : register( b0 )
{
	matrix World;
	matrix View;
	matrix Projection;
}

//--------------------------------------------------------------------------------------
struct VS_OUTPUT
{
    float4 Pos : SV_POSITION;
    float4 Color : COLOR0;
};


//--------------------------------------------------------------------------------------
// Vertex Shader
//--------------------------------------------------------------------------------------

/*Create Cornell
box by
using THREE
different vertexshaders.*/

VS_OUTPUT VS( float4 Pos : POSITION, float4 Color : COLOR )
{
    VS_OUTPUT output = (VS_OUTPUT)0;
    output.Pos = mul( Pos, World );
    output.Pos = mul( output.Pos, View );
    output.Pos = mul( output.Pos, Projection );
    output.Color = Color;
    return output;
}


//--------------------------------------------------------------------------------------
// Pixel Shader
//--------------------------------------------------------------------------------------
float4 PS( VS_OUTPUT input ) : SV_Target
{
    return input.Color;
}

float4 PS_Cube1( VS_OUTPUT input ) : SV_Target
{
    return float4(1.0f, 0.0f, 0.0f, 1.0f ); //red
}

float4 PS_Cube2( VS_OUTPUT input ) : SV_Target
{
    return float4(0.0f, 1.0f, 0.0f, 1.0f ); //green
}

float4 PS_Cube3( VS_OUTPUT input ) : SV_Target
{
    return float4(0.0f, 0.0f, 1.0f, 1.0f ); //blue
}

