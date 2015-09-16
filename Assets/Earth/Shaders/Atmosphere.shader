Shader "Earth/Atmosphere"
{
    Properties
    {
        _NightMap ("Night Light Map", 2D) = ""{}
        _NightColor ("Night Light", Color) = (0.5, 0.5, 0.3, 0)

        _RimColor ("Rim Color", Color) = (0.5, 0.5, 0.5, 0.0)
        _RimPower ("Rim Power", float) = 1.0
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }

        CGPROGRAM

        #pragma surface surf Earth alpha nolightmap
        #pragma target 3.0

        sampler2D _NightMap;
        half3 _NightColor;

        half3 _RimColor;
        half _RimPower;

        struct Input
        {
            float2 uv_NightMap;
        };

        half4 LightingEarth(SurfaceOutput s, half3 lightDir, half3 viewDir, half atten)
        {
            half ln = dot(lightDir, s.Normal);
            half vn = dot(viewDir, s.Normal);

            half rim = pow(1 - vn, _RimPower) * ln * atten;
            half night = -ln * ln * ln * s.Albedo.r;

            half4 c;
            c.rgb = lerp(_NightColor, _RimColor * _LightColor0.rgb, ln > 0);
            c.a = max(rim, night);
            return c;
        }

        void surf(Input IN, inout SurfaceOutput o)
        {
            o.Albedo = tex2D(_NightMap, IN.uv_NightMap);
        }

        ENDCG
    }
    Fallback "Diffuse"
}
