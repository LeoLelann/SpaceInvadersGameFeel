// Made with Amplify Shader Editor v1.9.8.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Ennemy_Death"
{
	Properties
	{
		[HideInInspector] _AlphaCutoff("Alpha Cutoff ", Range(0, 1)) = 0.5
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_TextureSample2("Texture Sample 1", 2D) = "white" {}
		_Scale_Y("Scale_Y", Float) = 1
		_Scale_X("Scale_X", Float) = 1
		_Scale_Y1("Scale_Y", Float) = 1
		_Scale_X1("Scale_X", Float) = 1
		_D_Min("D_Min", Range( -1 , 0)) = -1
		_D_max("D_max", Range( 0 , 1)) = 1
		_Distorsion_Intensity("Distorsion_Intensity", Range( 0 , 1)) = 0.2133948
		_Intensity_Max("Intensity_Max", Range( 0 , 3)) = 1.519757
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

		[HideInInspector][NoScaleOffset] unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset] unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset] unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
	}

	SubShader
	{
		LOD 0

		

		Tags { "RenderPipeline"="UniversalPipeline" "RenderType"="Transparent" "Queue"="Transparent" }

		Cull Off

		HLSLINCLUDE
		#pragma target 2.0
		#pragma prefer_hlslcc gles
		// ensure rendering platforms toggle list is visible

		#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
		#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Filtering.hlsl"

		ENDHLSL

		
		Pass
		{
			Name "Sprite Unlit"
            Tags { "LightMode"="Universal2D" }

			Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
			ZTest LEqual
			ZWrite Off
			Offset 0 , 0
			ColorMask RGBA
			

			HLSLPROGRAM

			#define ASE_VERSION 19801
			#define ASE_SRP_VERSION 170003


			#pragma vertex vert
			#pragma fragment frag

			#pragma multi_compile _ DEBUG_DISPLAY SKINNED_SPRITE

            #define _SURFACE_TYPE_TRANSPARENT 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_COLOR
            #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
            #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_COLOR
            #define FEATURES_GRAPH_VERTEX

			#define SHADERPASS SHADERPASS_SPRITEUNLIT

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Shaders/2D/Include/Core2D.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
			#include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#include "Packages/com.unity.render-pipelines.universal/Shaders/2D/Include/SurfaceData2D.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Debug/Debugging2D.hlsl"

			

			sampler2D _TextureSample1;
			sampler2D _TextureSample2;
			sampler2D _TextureSample0;
			CBUFFER_START( UnityPerMaterial )
			float4 _TextureSample0_ST;
			float _Intensity_Max;
			float _D_Min;
			float _D_max;
			float _Scale_X1;
			float _Scale_Y1;
			float _Distorsion_Intensity;
			float _Scale_X;
			float _Scale_Y;
			CBUFFER_END


			struct VertexInput
			{
				float3 positionOS : POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float4 uv0 : TEXCOORD0;
				float4 color : COLOR;
				
				UNITY_SKINNED_VERTEX_INPUTS
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 positionCS : SV_POSITION;
				float4 texCoord0 : TEXCOORD0;
				float4 color : TEXCOORD1;
				float3 positionWS : TEXCOORD2;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			#if ETC1_EXTERNAL_ALPHA
				TEXTURE2D(_AlphaTex); SAMPLER(sampler_AlphaTex);
				float _EnableAlphaTexture;
			#endif

			
			VertexOutput vert( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;

				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_SKINNED_VERTEX_COMPUTE( v );

				v.positionOS = UnityFlipSprite( v.positionOS, unity_SpriteProps.xy );

				
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.positionOS;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.positionOS = vertexValue;
				#else
					v.positionOS += vertexValue;
				#endif
				v.normal = v.normal;
				v.tangent.xyz = v.tangent.xyz;

				VertexPositionInputs vertexInput = GetVertexPositionInputs(v.positionOS);

				o.positionCS = vertexInput.positionCS;
				o.positionWS = vertexInput.positionWS;
				o.texCoord0 = v.uv0;
				o.color = v.color;
				return o;
			}

			half4 frag( VertexOutput IN  ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);

				float4 positionCS = IN.positionCS;
				float3 positionWS = IN.positionWS;

				float2 appendResult22 = (float2(1.0 , 0.49));
				float2 appendResult34 = (float2(0.9 , 0.87));
				float2 texCoord29 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult30 = (float2(_Scale_X1 , _Scale_Y1));
				float2 panner36 = ( 1.0 * _Time.y * appendResult34 + (texCoord29*appendResult30 + 0.0));
				float smoothstepResult38 = smoothstep( _D_Min , _D_max , tex2D( _TextureSample2, panner36 ).r);
				float2 texCoord16 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult18 = (float2(_Scale_X , _Scale_Y));
				float2 panner21 = ( 1.0 * _Time.y * appendResult22 + ( ( smoothstepResult38 * _Distorsion_Intensity ) + (texCoord16*appendResult18 + 0.0) ));
				float smoothstepResult51 = smoothstep( 0.0 , 1.13 , tex2D( _TextureSample1, panner21 ).r);
				float smoothstepResult59 = smoothstep( 0.0 , _Intensity_Max , smoothstepResult51);
				float2 texCoord82 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_85_0 = ( texCoord82.x - 0.0 );
				float temp_output_83_0 = ( texCoord82.y - 0.0 );
				float smoothstepResult91 = smoothstep( 0.0 , 0.06 , ( ( 1.0 - temp_output_85_0 ) * temp_output_85_0 * temp_output_83_0 * ( 1.0 - temp_output_83_0 ) ));
				float2 uv_TextureSample0 = IN.texCoord0.xy * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
				float smoothstepResult93 = smoothstep( 0.0 , 1.14 , tex2D( _TextureSample0, uv_TextureSample0 ).a);
				float4 temp_cast_0 = (( smoothstepResult59 * smoothstepResult91 * smoothstepResult93 )).xxxx;
				
				float4 Color = temp_cast_0;

				#if ETC1_EXTERNAL_ALPHA
					float4 alpha = SAMPLE_TEXTURE2D(_AlphaTex, sampler_AlphaTex, IN.texCoord0.xy);
					Color.a = lerp( Color.a, alpha.r, _EnableAlphaTexture);
				#endif

				#if defined(DEBUG_DISPLAY)
				SurfaceData2D surfaceData;
				InitializeSurfaceData(Color.rgb, Color.a, surfaceData);
				InputData2D inputData;
				InitializeInputData(positionWS.xy, half2(IN.texCoord0.xy), inputData);
				half4 debugColor = 0;

				SETUP_DEBUG_DATA_2D(inputData, positionWS, positionCS);

				if (CanDebugOverrideOutputColor(surfaceData, inputData, debugColor))
				{
					return debugColor;
				}
				#endif

				Color *= IN.color * unity_SpriteColor;
				return Color;
			}

			ENDHLSL
		}

		
		Pass
		{
			
            Name "Sprite Unlit Forward"
            Tags { "LightMode"="UniversalForward" }

			Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
			ZTest LEqual
			ZWrite Off
			Offset 0 , 0
			ColorMask RGBA
			

			HLSLPROGRAM

			#define ASE_VERSION 19801
			#define ASE_SRP_VERSION 170003


			#pragma vertex vert
			#pragma fragment frag

			#pragma multi_compile _ DEBUG_DISPLAY SKINNED_SPRITE

            #define _SURFACE_TYPE_TRANSPARENT 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_COLOR
            #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
            #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_COLOR
            #define FEATURES_GRAPH_VERTEX

			#define SHADERPASS SHADERPASS_SPRITEFORWARD

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Shaders/2D/Include/Core2D.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
			#include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#include "Packages/com.unity.render-pipelines.universal/Shaders/2D/Include/SurfaceData2D.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Debug/Debugging2D.hlsl"

			

			sampler2D _TextureSample1;
			sampler2D _TextureSample2;
			sampler2D _TextureSample0;
			CBUFFER_START( UnityPerMaterial )
			float4 _TextureSample0_ST;
			float _Intensity_Max;
			float _D_Min;
			float _D_max;
			float _Scale_X1;
			float _Scale_Y1;
			float _Distorsion_Intensity;
			float _Scale_X;
			float _Scale_Y;
			CBUFFER_END


			struct VertexInput
			{
				float3 positionOS : POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float4 uv0 : TEXCOORD0;
				float4 color : COLOR;
				
				UNITY_SKINNED_VERTEX_INPUTS
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 positionCS : SV_POSITION;
				float4 texCoord0 : TEXCOORD0;
				float4 color : TEXCOORD1;
				float3 positionWS : TEXCOORD2;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			#if ETC1_EXTERNAL_ALPHA
				TEXTURE2D( _AlphaTex ); SAMPLER( sampler_AlphaTex );
				float _EnableAlphaTexture;
			#endif

			
			VertexOutput vert( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_SKINNED_VERTEX_COMPUTE( v );

				v.positionOS = UnityFlipSprite( v.positionOS, unity_SpriteProps.xy );

				
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.positionOS;
				#else
					float3 defaultVertexValue = float3( 0, 0, 0 );
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.positionOS = vertexValue;
				#else
					v.positionOS += vertexValue;
				#endif
				v.normal = v.normal;
				v.tangent.xyz = v.tangent.xyz;

				VertexPositionInputs vertexInput = GetVertexPositionInputs(v.positionOS);

				o.positionCS = vertexInput.positionCS;
				o.positionWS = vertexInput.positionWS;
				o.texCoord0 = v.uv0;
				o.color = v.color;

				return o;
			}

			half4 frag( VertexOutput IN  ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);

				float4 positionCS = IN.positionCS;
				float3 positionWS = IN.positionWS;

				float2 appendResult22 = (float2(1.0 , 0.49));
				float2 appendResult34 = (float2(0.9 , 0.87));
				float2 texCoord29 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult30 = (float2(_Scale_X1 , _Scale_Y1));
				float2 panner36 = ( 1.0 * _Time.y * appendResult34 + (texCoord29*appendResult30 + 0.0));
				float smoothstepResult38 = smoothstep( _D_Min , _D_max , tex2D( _TextureSample2, panner36 ).r);
				float2 texCoord16 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult18 = (float2(_Scale_X , _Scale_Y));
				float2 panner21 = ( 1.0 * _Time.y * appendResult22 + ( ( smoothstepResult38 * _Distorsion_Intensity ) + (texCoord16*appendResult18 + 0.0) ));
				float smoothstepResult51 = smoothstep( 0.0 , 1.13 , tex2D( _TextureSample1, panner21 ).r);
				float smoothstepResult59 = smoothstep( 0.0 , _Intensity_Max , smoothstepResult51);
				float2 texCoord82 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_85_0 = ( texCoord82.x - 0.0 );
				float temp_output_83_0 = ( texCoord82.y - 0.0 );
				float smoothstepResult91 = smoothstep( 0.0 , 0.06 , ( ( 1.0 - temp_output_85_0 ) * temp_output_85_0 * temp_output_83_0 * ( 1.0 - temp_output_83_0 ) ));
				float2 uv_TextureSample0 = IN.texCoord0.xy * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
				float smoothstepResult93 = smoothstep( 0.0 , 1.14 , tex2D( _TextureSample0, uv_TextureSample0 ).a);
				float4 temp_cast_0 = (( smoothstepResult59 * smoothstepResult91 * smoothstepResult93 )).xxxx;
				
				float4 Color = temp_cast_0;

				#if ETC1_EXTERNAL_ALPHA
					float4 alpha = SAMPLE_TEXTURE2D( _AlphaTex, sampler_AlphaTex, IN.texCoord0.xy );
					Color.a = lerp( Color.a, alpha.r, _EnableAlphaTexture );
				#endif


				#if defined(DEBUG_DISPLAY)
					SurfaceData2D surfaceData;
					InitializeSurfaceData(Color.rgb, Color.a, surfaceData);
					InputData2D inputData;
					InitializeInputData(positionWS.xy, half2(IN.texCoord0.xy), inputData);
					half4 debugColor = 0;

					SETUP_DEBUG_DATA_2D(inputData, positionWS, positionCS);

					if (CanDebugOverrideOutputColor(surfaceData, inputData, debugColor))
					{
						return debugColor;
					}
				#endif

				Color *= IN.color * unity_SpriteColor;
				return Color;
			}

			ENDHLSL
		}
		
        Pass
        {
			
            Name "SceneSelectionPass"
            Tags { "LightMode"="SceneSelectionPass" }

            Cull Off

            HLSLPROGRAM

			#define ASE_VERSION 19801
			#define ASE_SRP_VERSION 170003


			#pragma vertex vert
			#pragma fragment frag

			#pragma multi_compile _ DEBUG_DISPLAY SKINNED_SPRITE

            #define _SURFACE_TYPE_TRANSPARENT 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
            #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
            #define FEATURES_GRAPH_VERTEX

            #define SHADERPASS SHADERPASS_DEPTHONLY
			#define SCENESELECTIONPASS 1

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Shaders/2D/Include/Core2D.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
			#include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			

			sampler2D _TextureSample1;
			sampler2D _TextureSample2;
			sampler2D _TextureSample0;
			CBUFFER_START( UnityPerMaterial )
			float4 _TextureSample0_ST;
			float _Intensity_Max;
			float _D_Min;
			float _D_max;
			float _Scale_X1;
			float _Scale_Y1;
			float _Distorsion_Intensity;
			float _Scale_X;
			float _Scale_Y;
			CBUFFER_END


            struct VertexInput
			{
				float3 positionOS : POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_SKINNED_VERTEX_INPUTS
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 positionCS : SV_POSITION;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

            int _ObjectId;
            int _PassValue;

			
			VertexOutput vert(VertexInput v )
			{
				VertexOutput o = (VertexOutput)0;

				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_SKINNED_VERTEX_COMPUTE(v);

				v.positionOS = UnityFlipSprite( v.positionOS, unity_SpriteProps.xy );

				o.ase_texcoord.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.zw = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.positionOS;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.positionOS = vertexValue;
				#else
					v.positionOS += vertexValue;
				#endif

				VertexPositionInputs vertexInput = GetVertexPositionInputs(v.positionOS);
				float3 positionWS = TransformObjectToWorld(v.positionOS);
				o.positionCS = TransformWorldToHClip(positionWS);

				return o;
			}

			half4 frag(VertexOutput IN) : SV_TARGET
			{
				float2 appendResult22 = (float2(1.0 , 0.49));
				float2 appendResult34 = (float2(0.9 , 0.87));
				float2 texCoord29 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult30 = (float2(_Scale_X1 , _Scale_Y1));
				float2 panner36 = ( 1.0 * _Time.y * appendResult34 + (texCoord29*appendResult30 + 0.0));
				float smoothstepResult38 = smoothstep( _D_Min , _D_max , tex2D( _TextureSample2, panner36 ).r);
				float2 texCoord16 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult18 = (float2(_Scale_X , _Scale_Y));
				float2 panner21 = ( 1.0 * _Time.y * appendResult22 + ( ( smoothstepResult38 * _Distorsion_Intensity ) + (texCoord16*appendResult18 + 0.0) ));
				float smoothstepResult51 = smoothstep( 0.0 , 1.13 , tex2D( _TextureSample1, panner21 ).r);
				float smoothstepResult59 = smoothstep( 0.0 , _Intensity_Max , smoothstepResult51);
				float2 texCoord82 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_85_0 = ( texCoord82.x - 0.0 );
				float temp_output_83_0 = ( texCoord82.y - 0.0 );
				float smoothstepResult91 = smoothstep( 0.0 , 0.06 , ( ( 1.0 - temp_output_85_0 ) * temp_output_85_0 * temp_output_83_0 * ( 1.0 - temp_output_83_0 ) ));
				float2 uv_TextureSample0 = IN.ase_texcoord.xy * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
				float smoothstepResult93 = smoothstep( 0.0 , 1.14 , tex2D( _TextureSample0, uv_TextureSample0 ).a);
				float4 temp_cast_0 = (( smoothstepResult59 * smoothstepResult91 * smoothstepResult93 )).xxxx;
				
				float4 Color = temp_cast_0;

				half4 outColor = half4(_ObjectId, _PassValue, 1.0, 1.0);
				return outColor;
			}

            ENDHLSL
        }

		
        Pass
        {
			
            Name "ScenePickingPass"
            Tags { "LightMode"="Picking" }

			Cull Off

            HLSLPROGRAM

			#define ASE_VERSION 19801
			#define ASE_SRP_VERSION 170003


			#pragma vertex vert
			#pragma fragment frag

			#pragma multi_compile _ DEBUG_DISPLAY SKINNED_SPRITE

            #define _SURFACE_TYPE_TRANSPARENT 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
            #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
            #define FEATURES_GRAPH_VERTEX

            #define SHADERPASS SHADERPASS_DEPTHONLY
			#define SCENEPICKINGPASS 1

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Shaders/2D/Include/Core2D.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
			#include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

        	

			sampler2D _TextureSample1;
			sampler2D _TextureSample2;
			sampler2D _TextureSample0;
			CBUFFER_START( UnityPerMaterial )
			float4 _TextureSample0_ST;
			float _Intensity_Max;
			float _D_Min;
			float _D_max;
			float _Scale_X1;
			float _Scale_Y1;
			float _Distorsion_Intensity;
			float _Scale_X;
			float _Scale_Y;
			CBUFFER_END


            struct VertexInput
			{
				float3 positionOS : POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_SKINNED_VERTEX_INPUTS
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 positionCS : SV_POSITION;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

            float4 _SelectionID;

			
			VertexOutput vert(VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;

				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_SKINNED_VERTEX_COMPUTE(v);

				v.positionOS = UnityFlipSprite( v.positionOS, unity_SpriteProps.xy );

				o.ase_texcoord.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.zw = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.positionOS;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.positionOS = vertexValue;
				#else
					v.positionOS += vertexValue;
				#endif

				VertexPositionInputs vertexInput = GetVertexPositionInputs(v.positionOS);
				float3 positionWS = TransformObjectToWorld(v.positionOS);
				o.positionCS = TransformWorldToHClip(positionWS);

				return o;
			}

			half4 frag(VertexOutput IN ) : SV_TARGET
			{
				float2 appendResult22 = (float2(1.0 , 0.49));
				float2 appendResult34 = (float2(0.9 , 0.87));
				float2 texCoord29 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult30 = (float2(_Scale_X1 , _Scale_Y1));
				float2 panner36 = ( 1.0 * _Time.y * appendResult34 + (texCoord29*appendResult30 + 0.0));
				float smoothstepResult38 = smoothstep( _D_Min , _D_max , tex2D( _TextureSample2, panner36 ).r);
				float2 texCoord16 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult18 = (float2(_Scale_X , _Scale_Y));
				float2 panner21 = ( 1.0 * _Time.y * appendResult22 + ( ( smoothstepResult38 * _Distorsion_Intensity ) + (texCoord16*appendResult18 + 0.0) ));
				float smoothstepResult51 = smoothstep( 0.0 , 1.13 , tex2D( _TextureSample1, panner21 ).r);
				float smoothstepResult59 = smoothstep( 0.0 , _Intensity_Max , smoothstepResult51);
				float2 texCoord82 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_85_0 = ( texCoord82.x - 0.0 );
				float temp_output_83_0 = ( texCoord82.y - 0.0 );
				float smoothstepResult91 = smoothstep( 0.0 , 0.06 , ( ( 1.0 - temp_output_85_0 ) * temp_output_85_0 * temp_output_83_0 * ( 1.0 - temp_output_83_0 ) ));
				float2 uv_TextureSample0 = IN.ase_texcoord.xy * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
				float smoothstepResult93 = smoothstep( 0.0 , 1.14 , tex2D( _TextureSample0, uv_TextureSample0 ).a);
				float4 temp_cast_0 = (( smoothstepResult59 * smoothstepResult91 * smoothstepResult93 )).xxxx;
				
				float4 Color = temp_cast_0;
				half4 outColor = _SelectionID;
				return outColor;
			}

            ENDHLSL
        }
		
	}
	CustomEditor "UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI"
	FallBack "Hidden/Shader Graph/FallbackError"
	
	Fallback Off
}
/*ASEBEGIN
Version=19801
Node;AmplifyShaderEditor.RangedFloatNode;31;-2608,-128;Inherit;False;Property;_Scale_Y1;Scale_Y;4;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-2624,-240;Inherit;False;Property;_Scale_X1;Scale_X;5;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-2512,48;Inherit;False;Constant;_Float2;Float 0;4;0;Create;True;0;0;0;False;0;False;0.9;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-2512,128;Inherit;False;Constant;_Float3;Float 1;4;0;Create;True;0;0;0;False;0;False;0.87;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;30;-2448,-272;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;29;-2688,-432;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;34;-2304,64;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;28;-2272,-432;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;1,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;36;-1920,-432;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-1376,400;Inherit;False;Property;_Scale_Y;Scale_Y;2;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-1392,288;Inherit;False;Property;_Scale_X;Scale_X;3;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;37;-1728,-432;Inherit;True;Property;_TextureSample2;Texture Sample 1;1;0;Create;True;0;0;0;False;0;False;-1;c61e12b00f19ecd448a748ee4f011b63;c61e12b00f19ecd448a748ee4f011b63;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode;40;-1760,-208;Inherit;False;Property;_D_Min;D_Min;6;0;Create;True;0;0;0;False;0;False;-1;0;-1;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-1760,-112;Inherit;False;Property;_D_max;D_max;7;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;16;-1456,96;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;18;-1213.81,269.5693;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SmoothstepOpNode;38;-1424,-432;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1.38;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-1424,-80;Inherit;False;Property;_Distorsion_Intensity;Distorsion_Intensity;8;0;Create;True;0;0;0;False;0;False;0.2133948;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;17;-1144.13,100.0494;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-1040,432;Inherit;False;Constant;_Float0;Float 0;4;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-1040,512;Inherit;False;Constant;_Float1;Float 1;4;0;Create;True;0;0;0;False;0;False;0.49;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-1136,-304;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;26;-912,-112;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;22;-843.6049,444.8486;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;82;-752,-1008;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;21;-784,96;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;83;-480,-1008;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;85;-464,-752;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;12;-528,80;Inherit;True;Property;_TextureSample1;Texture Sample 1;0;0;Create;True;0;0;0;False;0;False;-1;c61e12b00f19ecd448a748ee4f011b63;c61e12b00f19ecd448a748ee4f011b63;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.OneMinusNode;84;-240,-1152;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;86;-224,-656;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;52;176,288;Inherit;False;Constant;_Float4;Float 4;10;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;53;192,368;Inherit;False;Property;_Intensity_Max;Intensity_Max;9;0;Create;True;0;0;0;False;0;False;1.519757;0.21;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;51;160,0;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1.13;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;87;64,-976;Inherit;True;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;92;80,-560;Inherit;True;Property;_TextureSample0;Texture Sample 0;10;0;Create;True;0;0;0;False;0;False;-1;75967f538f9ebc7418716e51d1f07c37;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SmoothstepOpNode;59;464,0;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;91;304,-896;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.06;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;93;448,-544;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1.14;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;89;848,-224;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;48;448,16;Float;False;False;-1;3;UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI;0;1;New Amplify Shader;cf964e524c8e69742b1d21fbe2ebcc4a;True;Sprite Unlit Forward;0;1;Sprite Unlit Forward;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;0;True;12;all;0;False;True;2;5;False;;10;False;;3;1;False;;10;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;2;False;;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=UniversalForward;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;49;448,16;Float;False;False;-1;3;UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI;0;1;New Amplify Shader;cf964e524c8e69742b1d21fbe2ebcc4a;True;SceneSelectionPass;0;2;SceneSelectionPass;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;0;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=SceneSelectionPass;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;50;448,16;Float;False;False;-1;3;UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI;0;1;New Amplify Shader;cf964e524c8e69742b1d21fbe2ebcc4a;True;ScenePickingPass;0;3;ScenePickingPass;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;0;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Picking;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;47;1312,-96;Float;False;True;-1;3;UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI;0;15;Ennemy_Death;cf964e524c8e69742b1d21fbe2ebcc4a;True;Sprite Unlit;0;0;Sprite Unlit;4;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;0;True;12;all;0;False;True;2;5;False;;10;False;;3;1;False;;10;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;2;False;;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=Universal2D;False;False;0;;0;0;Standard;3;Vertex Position;1;0;Debug Display;0;0;External Alpha;0;0;0;4;True;True;True;True;False;;False;0
WireConnection;30;0;32;0
WireConnection;30;1;31;0
WireConnection;34;0;33;0
WireConnection;34;1;35;0
WireConnection;28;0;29;0
WireConnection;28;1;30;0
WireConnection;36;0;28;0
WireConnection;36;2;34;0
WireConnection;37;1;36;0
WireConnection;18;0;19;0
WireConnection;18;1;20;0
WireConnection;38;0;37;1
WireConnection;38;1;40;0
WireConnection;38;2;41;0
WireConnection;17;0;16;0
WireConnection;17;1;18;0
WireConnection;27;0;38;0
WireConnection;27;1;42;0
WireConnection;26;0;27;0
WireConnection;26;1;17;0
WireConnection;22;0;23;0
WireConnection;22;1;24;0
WireConnection;21;0;26;0
WireConnection;21;2;22;0
WireConnection;83;0;82;2
WireConnection;85;0;82;1
WireConnection;12;1;21;0
WireConnection;84;0;83;0
WireConnection;86;0;85;0
WireConnection;51;0;12;1
WireConnection;87;0;86;0
WireConnection;87;1;85;0
WireConnection;87;2;83;0
WireConnection;87;3;84;0
WireConnection;59;0;51;0
WireConnection;59;1;52;0
WireConnection;59;2;53;0
WireConnection;91;0;87;0
WireConnection;93;0;92;4
WireConnection;89;0;59;0
WireConnection;89;1;91;0
WireConnection;89;2;93;0
WireConnection;47;1;89;0
ASEEND*/
//CHKSM=9B50A537D2916B0EF155B2397480DE8346C26685