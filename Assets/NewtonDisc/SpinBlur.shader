//Taken from https://forum.unity.com/threads/radial-blur-shader-texture.406804/
//Shared by https://forum.unity.com/members/fra3point.125556/

Shader "Custom/SpinBlur"{
	Properties{
		_Color("Main Color", Color) = (1,1,1,1)
		_Samples("Samples", Range(0,360)) = 100
		_Angle("Angle", Range(-360,360)) = 10
		_MainTex("Color (RGB) Alpha (A)", 2D) = "white"
	}
		SubShader{
		Tags{ "Queue" = "Transparent" "RenderType" = "Transparent" }

		LOD 200
		Cull Off

		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Lambert alpha

		sampler2D _MainTex;
		int _Angle;
		int _Samples;
		float4 _Color;

		struct Input {
			float2 uv_MainTex;
			float4 screenPos;
		};

		float2 rotateUV(float2 uv, float degrees) {
			const float Deg2Rad = (UNITY_PI * 2.0) / 360.0;
			float rotationRadians = degrees * Deg2Rad;
			float s = sin(rotationRadians);
			float c = cos(rotationRadians);
			float2x2 rotationMatrix = float2x2(c, -s, s, c);
			uv -= 0.5;
			uv = mul(rotationMatrix, uv);
			uv += 0.5;
			return uv;
		}

		void surf(Input IN, inout SurfaceOutput o) {
			float2 vUv = IN.uv_MainTex;
			float2 coord = vUv;
			float4 FragColor = float4(0.0, 0.0, 0.0, 0.0);
			int samp = _Samples;
			if (samp <= 0) samp = 1;
			float rotationAngle = (float)_Angle / (float)samp;
			float sampleWeight = 1.0 / samp;
			for (float i = 0; i < samp; i++) {
				coord = rotateUV(coord, rotationAngle);
				float4 texel = tex2D(_MainTex, coord);
				texel *= sampleWeight;
				FragColor += texel;
			}
			float4 c = FragColor * _Color;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
		FallBack "Diffuse"
}