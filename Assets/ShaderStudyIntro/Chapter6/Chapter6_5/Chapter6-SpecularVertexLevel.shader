﻿Shader "Unity Shaders Book/Chapter 6/Specular Vertex-Level" {
	 Properties {
	 	 _Diffuse ("Diffuse", Color) = (1,1,1,1)
		 _Specular ("Specular", Color) = (1,1,1,1)
		 _Gloss ("Gloss", Range(8.0, 256)) = 20
	 }
	 SubShader {
	 	 Pass {
		 	 Tags {"LightMode" = "ForwardBase"}
			 
			 CGPROGRAM

			 #pragma vertex vert
			 #pragma fragment frag

			 #include "Lighting.cginc"

			 fixed4 _Diffuse;
			 fixed4 _Specular;
			 float _Gloss;

			 struct a2v {
			 	 float4 vertex : POSITION;
				 float3 normal : NORMAL;
			 };

			 struct v2f { 
			 	 float4 pos : SV_POSITION;
				 fixed3 color :  COLOR;
			 };

			 v2f vert(a2v v) {
			 	 v2f o;

				 // 顶点坐标从模型空间转向裁剪空间
				 o.pos = UnityObjectToClipPos(v.vertex);
				 // 获取环境光
				 fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
				 // 法线从模型空间转向世界空，并归一化
				 fixed3 worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));
				 // 获取光源在世界空间的方向，并归一化
				 fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);

				 // 计算漫反射
				 fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLightDir));
				 // 获取反射方向，并归一化
				 fixed3 reflectDir = normalize(reflect(-worldLightDir, worldNormal));
				 // 获取世界空间中的观察方向
				 fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - mul(unity_ObjectToWorld, v.vertex).xyz);
				 // 计算高光反射
				 fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(saturate(dot(reflectDir, viewDir)), _Gloss);

				 o.color = ambient + diffuse + specular;

				 return o;
			 }

			 fixed4 frag(v2f i) : SV_Target {
			 	 return fixed4(i.color, 1.0);
			 }

			 ENDCG
		 }
	 }
	 Fallback "Specular"
}
