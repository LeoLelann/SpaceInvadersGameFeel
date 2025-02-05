// Made with Amplify Shader Editor v1.9.8.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "PIXEL"
{
	Properties
	{
		_PixelX("Pixel X", Range( 0 , 5000)) = 200
		_PixelY("Pixel Y", Range( 0 , 5000)) = 200

	}

	SubShader
	{
		LOD 0

		Cull Off
		ZWrite Off
		ZTest Always
		
		Pass
		{
			CGPROGRAM

			#define ASE_VERSION 19801


			#pragma vertex Vert
			#pragma fragment Frag
			#pragma target 3.5

			#include "UnityCG.cginc"
			

			struct ASEAttributesDefault
			{
				float3 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				
			};

			struct ASEVaryingsDefault
			{
				float4 vertex : SV_POSITION;
				float2 texcoord : TEXCOORD0;
				float2 texcoordStereo : TEXCOORD1;
			#if STEREO_INSTANCING_ENABLED
				uint stereoTargetEyeIndex : SV_RenderTargetArrayIndex;
			#endif
				
			};

			uniform sampler2D _MainTex;
			uniform half4 _MainTex_TexelSize;
			uniform half4 _MainTex_ST;

			uniform float _PixelX;
			uniform float _PixelY;


			
			float2 TransformTriangleVertexToUV (float2 vertex)
			{
				float2 uv = (vertex + 1.0) * 0.5;
				return uv;
			}

			ASEVaryingsDefault Vert( ASEAttributesDefault v  )
			{
				ASEVaryingsDefault o;
				o.vertex = float4(v.vertex.xy, 0.0, 1.0);
				o.texcoord = TransformTriangleVertexToUV (v.vertex.xy);
#if UNITY_UV_STARTS_AT_TOP
				o.texcoord = o.texcoord * float2(1.0, -1.0) + float2(0.0, 1.0);
#endif
				o.texcoordStereo = TransformStereoScreenSpaceTex (o.texcoord, 1.0);

				v.texcoord = o.texcoordStereo;
				float4 ase_ppsScreenPosVertexNorm = float4(o.texcoordStereo,0,1);

				

				return o;
			}

			float4 Frag (ASEVaryingsDefault i  ) : SV_Target
			{
				float4 ase_ppsScreenPosFragNorm = float4(i.texcoordStereo,0,1);

				float2 texCoord4 = i.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float pixelWidth3 =  1.0f / _PixelX;
				float pixelHeight3 = 1.0f / _PixelY;
				half2 pixelateduv3 = half2((int)(texCoord4.x / pixelWidth3) * pixelWidth3, (int)(texCoord4.y / pixelHeight3) * pixelHeight3);
				

				float4 color = tex2D( _MainTex, pixelateduv3 );

				return color;
			}
			ENDCG
		}
	}
	CustomEditor "AmplifyShaderEditor.MaterialInspector"
	
	Fallback Off
}
/*ASEBEGIN
Version=19801
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-800,400;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;5;-704,544;Inherit;False;Property;_PixelX;Pixel X;0;0;Create;True;0;0;0;False;0;False;200;0;0;5000;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-384,592;Inherit;False;Property;_PixelY;Pixel Y;1;0;Create;True;0;0;0;False;0;False;200;0;0;5000;0;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;1;-560,144;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCPixelate;3;-480,400;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;2;-224,80;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;128,80;Float;False;True;-1;3;AmplifyShaderEditor.MaterialInspector;0;8;PIXEL;32139be9c1eb75640a847f011acf3bcf;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;True;7;False;;False;False;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;False;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;3;0;4;0
WireConnection;3;1;5;0
WireConnection;3;2;6;0
WireConnection;2;0;1;0
WireConnection;2;1;3;0
WireConnection;0;0;2;0
ASEEND*/
//CHKSM=7EFD9AC672368F4C9455B64E335A7AE3AA1627DC