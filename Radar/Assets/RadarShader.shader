Shader "Unlit/RadarShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_FValue("Rot_Value",float) = 0
		
		//_FDIST("Dist_Value",float[3]) = {1,2,1}
		
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
			uniform float _FValue;
			uniform float _FDIST[360];

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }
			#define PI 3.14159265359

			float main_range(float2 st) {
				float r = distance(st, float2(0.5, 0.5));
				return step(r, 0.5);
			}

			float4 disc_guide(float2 st,float radius, float width) {
				fixed r = distance(st,fixed2(0.5,0.5));
				return step(radius - width, r)*step(1 - radius,1-r);
			}

			float disc(float2 st) {

				return  disc_guide(st, 0.1, 0.01) + disc_guide(st, 0.3, 0.01) + disc_guide(st, 0.5, 0.01);
				//50 0.4
			}

			float grad_rot(float2 st,float width) {

				float dx = 0.5 - st.x;
				float dy = 0.5 - st.y;
				float rad = atan2(dx, dy);
				rad = rad * 180 / PI;
				rad = rad + 180;


				float offset = (_FValue ) % 360;
				float offset2 = (_FValue  + 60) % 360;

				float d1 = distance(rad, offset) / width;
				float d2 = distance(rad, offset+360) / width;
				float d3 = distance(rad, offset-360) / width;

				return 1-min(min(d1, d2), d3);
			}

			float main_radar(float2 st) {

				float dx = 0.5 - st.x;
				float dy = 0.5 - st.y;
				float rad = atan2(dx, dy);
				rad = rad * 180 / PI;
				rad = rad + 180;


				float offset = (_FValue ) % 360;
				float offset2 = (_FValue ) % 360 + 360;

				float s1 = step(rad, offset);
				float s2 = step(offset-60, rad);
				float s3 = step(rad, offset2);
				float s4 = step(offset2-60, rad);

				return (s1 * s2 + s3 * s4) *grad_rot(st,60)+disc(st);
			}

			float main_position(float2 st) {
				float dx = 0.5 - st.x;
				float dy = 0.5 - st.y;
				float rad = atan2(dx, dy);
				rad = (rad * 180 / PI ) +179;

				float r = distance(st, fixed2(0.5, 0.5));
				float dist = _FDIST[rad];


				return (step(dist + 2.0f,r) * step(r, dist + 2.05f));
			}


			

			fixed4 frag(v2f i) : SV_Target
			{
				float2 st = i.uv;

				fixed4 black = fixed4(0,0,0,0);
				fixed4 write = fixed4(1, 1, 1, 1);
				fixed4 green = fixed4(0, 1, 0, 0);

				return lerp(black, green, (main_position(st) + main_radar(st)) * main_range(st));
            }
            ENDCG
        }
    }
}
