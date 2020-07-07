Shader "Unity Shaders Book/Chapter 6/Diffuse Vertex-Level" {
	Properties {
		_Diffuse ("Diffuse", Color) = (1, 1, 1, 1)
	}
	SubShader {
		Pass {
			Tags { "LightMode" = "ForwardBase" }

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "Lighting.cginc"

			fixed4 _Diffuse;

			struct a2v {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f {
				float4 pos : SV_POSITION;
				fixed3 color : COLOR;
			};

			v2f vert(a2v v) {
				v2f o;
				// 顶点坐标从模型空间转向裁剪空间
				o.pos = UnityObjectToClipPos(v.vertex);

				// 获取环境光
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

				// 法线从模型空间转向世界空间
				fixed3 worldNormal = normalize(mul(v.normal, (float3x3) unity_WorldToObject)); // 笔记：新版本中 unity_WorldToObject 替换了 _World2Object
				// 获取世界空间的光源方向
				fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);
				// 计算获得漫射光
				fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLight));

				o.color = ambient + diffuse;

				return o;
			}

			fixed4 frag(v2f i) : SV_Target {
				return fixed4(i.color, 1.0);
			}

			ENDCG
		}
	}
	Fallback "Diffuse"
}