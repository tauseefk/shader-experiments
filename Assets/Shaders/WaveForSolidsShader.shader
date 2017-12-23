// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Unlit/WaveForSolidsShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Scale ("Scale", float) = 1
		_Speed ("Speed", float) = 1
		_Frequency ("Frequency", float) = 1
		_Color ("Main Color", Color) = (1, 1, 1, 1)
		_SecondaryColor ("Secondary Color", Color) = (1, 1, 1, 1)
		[HDR] _EmissionColor ("Emission Color", Color) = (0,0,0)
        _Threshold ("Threshold", Range(0.0, 1.0)) = 1.0
        _OffsetX ("Offset X", float) = 0.0
        _OffsetZ ("Offset Z", float) = 0.0
        _Amplitude ("Amplitude", float) = 0.0
        _WaveTravelDistance ("Wave Travel Distance", float) = 0.0
        _WaveTravelRange ("Wave Travel Range", float) = 50.0
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 200

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				fixed3 color : COLOR0;
				half3 normal : TEXCOORD0;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _Scale, _Speed, _Frequency, _Threshold, _Amplitude, _OffsetX, _OffsetZ, _WaveTravelDistance, _WaveTravelRange;
			fixed4 _Color, _SecondaryColor, _EmissionColor;

			v2f vert (appdata v, float3 normal : NORMAL)
			{
				v2f o;
				float4 worldPos = mul(UNITY_MATRIX_M, v.vertex);
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.normal = UnityObjectToWorldNormal(normal);

				half c_offsetvert = pow(worldPos.x - _OffsetX, 2) + pow(worldPos.z - _OffsetZ, 2);

				fixed3 emi = _EmissionColor.rgb * _Threshold;
				fixed3 tempColor = _EmissionColor.rgb * sin(_Speed * _Time.w + _Frequency * c_offsetvert) + emi;

				float impactDistance = sqrt(c_offsetvert);

				if(impactDistance < _WaveTravelDistance && impactDistance > _WaveTravelDistance - _WaveTravelRange) {
					_Amplitude /= smoothstep(0.0, _WaveTravelDistance, impactDistance);
				} else {
					_Amplitude = 0.0;
				}
				tempColor *= _Amplitude;
				o.color.rgb = tempColor;
				return o;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = 0;
				col.rgb = i.color.rgb;
				return col;
			}
			ENDCG
		}
	}
}
