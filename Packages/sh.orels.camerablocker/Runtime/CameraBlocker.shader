Shader "orels1/Camera Blocker"
{
	Properties
	{
		[ToggleUI]_Enabled("Enabled", Int) = 1
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" "Queue"="Overlay+1000" }
		ZTest Always
		Stencil {
			Ref 69
			Comp Equal
		}

		Pass
		{
			Tags { "LightMode" = "ForwardBase" }
			Cull Front
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#pragma multi_compile_fwdbase

            #ifndef UNITY_PASS_FORWARDBASE
                #define UNITY_PASS_FORWARDBASE
            #endif
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float4 color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float4 color : COLOR;
				float3 localPos: LOCALPOS;
				float3 worldPos : WORLDPOS;
				UNITY_VERTEX_OUTPUT_STEREO
			};

			float _VRChatCameraMode;
			int _Enabled;
			
			v2f vert (appdata v)
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
			    UNITY_INITIALIZE_OUTPUT(v2f, o);
			    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.localPos = v.vertex.xyz;
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				o.color = v.color;
				o.uv = v.uv;
				// YEET vertex if we're not in the camera
				if ((_VRChatCameraMode != 1 && _VRChatCameraMode != 2) || !_Enabled)
				{
					o.vertex.xyz = 0.0 / 0.0;
				}
				return o;
			}
			fixed4 frag (v2f i) : SV_Target
			{
				return half4(0,0,0,1);
			}
			ENDCG
		}
		
		Pass {
	        Tags {"LightMode" = "ShadowCaster"}
			ZTest Always
			Cull Off
	        CGPROGRAM
	        #pragma vertex vert
	        #pragma fragment frag
	        #pragma multi_compile_instancing
	        #pragma multi_compile_shadowcaster
	        #include "UnityCG.cginc"

	        struct appdata {
	            float4 vertex : POSITION;
	            float3 normal : NORMAL;
	            UNITY_VERTEX_INPUT_INSTANCE_ID
	        };

	        struct v2f {
	            float4 pos : SV_POSITION;
	            UNITY_VERTEX_INPUT_INSTANCE_ID 
	            UNITY_VERTEX_OUTPUT_STEREO
	        };

	        v2f vert (appdata v){
	            v2f o = (v2f)0;
	            UNITY_SETUP_INSTANCE_ID(v);
	            UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
	            TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
	            return o;
	        }

	        float4 frag (v2f i) : SV_Target {
	            UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
	            return 0;
	        }
	        ENDCG
	    }
	}
}