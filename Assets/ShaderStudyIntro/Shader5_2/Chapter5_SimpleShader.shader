// 笔记：本 shader 实现一个最简单的着色器，旨在了解变量、语义块、函数、语义、结构体等定义
Shader "Unity Shaders Book/Chapter 5/Simple Shader" {
	Properties{
		// 声明一个 Color 类型的属性 笔记：暴露在面板上
		// 第一个字段为 变量名
		// 第二个字段为 在面板上的名称
		// 第三个字段为 变量类型
		_Color ("Color Tint", Color) = (1.0,1.0,1.0,1.0)
	}
	SubShader {
		Pass {
			CGPROGRAM

			// 顶点着色器指定函数
			#pragma vertex vert
			// 片元着色器指定函数
			#pragma fragment frag

			// 在 CG 代码中，我们需要定义一个与属性名称和类型都匹配的变量
			// 笔记：在这里定义之后才能在语义块中调用
			fixed4 _Color;

			// 使用一个结构体定义顶点着色器的输入。笔记：定义时即对所有成员进行了赋值
			struct a2v {
				// POSITION 语义告诉 Unity，用模型空贱得顶点坐标填充 vertex 变量
				float4 vertex : POSITION;
				// NORMAL 语义告诉 Unity，用模型空间的发现方向填充 normal 变量
				float3 normal : NORMAL;
				// TEXCOORD0 语义告诉 Unity，用模型的第一套纹理坐标填充 texcoord 变量，TEXCOORD0 最后一个字符应该是 零
				float4 texcoord : TEXCOORD0;
			};

			// 使用一个结构体来定义顶点着色器的输出
			struct v2f {
				// SV_POSITION 语义告诉 Unity，pos 里包含了顶点在裁剪空间中的位置信息
				float4 pos : SV_POSITION;
				// COLOR0 语义可以用于存储颜色信息
				fixed3 color : COLOR0;
			};

			// 笔记： a2f 结构体中包含了 SV_POSITION 语义，所以这里没有 SV_POSITION 语义
			v2f vert(a2v v) {
			
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);		// 笔记：从 Unity5.6 开始，mul(UNITY_MATRIX_MVP, *) 被 UnityObjectToClipPos(*) 取代
				o.color = v.normal * 0.5 + fixed3(0.5, 0.5, 0.5);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target {
				fixed3 c = i.color;
				c *= _Color.rgb;
				return fixed4(c, 1.0);
			}

			ENDCG
		}
	}
}