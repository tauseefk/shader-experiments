// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Unlit/WaveShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Scale ("Scale", float) = 1
		_Speed ("Speed", float) = 1
		_Frequency ("Frequency", float) = 1
		_Color ("Main Color", Color) = (1, 1, 1, 1)
    	_EmissionLM ("Emission (Lightmapper)", Float) = 0
   		[Toggle] _DynamicEmissionLM ("Dynamic Emission (Lightmapper)", Int) = 0
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

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
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
				fixed3 color : COLOR0;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _Scale, _Speed, _Frequency;
			fixed4 _Color;

			v2f vert (appdata v, float3 normal : NORMAL)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				half offsetvert = v.vertex.x * v.vertex.x + v.vertex.z * v.vertex.z;
				half value = _Scale * sin(_Speed * _Time.w + _Frequency * offsetvert);
				o.vertex.y += value;
//				o.vertex.x += _Scale * sin(_Speed * _Time.w + o.vertex.y);
				o.color = _Color;
        		half c_offsetvert = mul(unity_ObjectToWorld, v.vertex).x * mul(unity_ObjectToWorld, v.vertex).x + mul(unity_ObjectToWorld, v.vertex).z * mul(unity_ObjectToWorld, v.vertex).z;
        		o.color.r = _Color.r * sin(_Speed * _Time.w + _Frequency * c_offsetvert);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = 0;
				col.rgb = i.color;
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
}
