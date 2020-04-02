﻿Shader "Unlit/AbeletonScaneLine"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_NoisePower("NoisePower", Float) = 0.0
    
	}
    SubShader
    {
        Tags { "RenderType"="Opaque" }
		Cull Off
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"
			#include "Assets/ShaderUtils/Noise4d.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }


			float _NoisePower;
			float brightWhiteNoise;
            fixed4 frag (v2f i) : SV_Target
            {
				float2 uv = i.uv;
				uv.y = 1.0 - uv.y;
                
				//float3 noise = snoise3D(float4(i.uv.x, i.uv.y, _Time.y, 0.0));
				//noise.xy *= _NoisePower;
				//uv += noise.xy;
				//uv = frac(uv);
				uv.x = smoothstep(0.0 , 1.0 , uv.x + brightWhiteNoise) ;
				fixed4 col = tex2D(_MainTex, uv);
			
				//UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
