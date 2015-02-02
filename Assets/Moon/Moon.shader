Shader "Custom/Moon"
{
    Properties
    {
        _ColorMap("Color Map", CUBE) = ""{}
        _NormalMap("Normal Map", 2D) = ""{}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        
        CGPROGRAM
        #pragma surface surf Moon nolightmap vertex:vert

        samplerCUBE _ColorMap;
        sampler2D _NormalMap;

        half4 LightingMoon(SurfaceOutput s, half3 lightDir, half atten)
        {
            half ln = dot(lightDir, s.Normal);
            return half4(s.Albedo * _LightColor0.rgb * (max(0, ln) * atten), 1);
        }

        struct Input
        {
            float2 uv_NormalMap;
            float3 localNormal;
        };

        void vert(inout appdata_full v, out Input o)
        {
            UNITY_INITIALIZE_OUTPUT(Input, o);
            o.localNormal = v.normal * float3(-1, 1, 1);
        }

        void surf(Input IN, inout SurfaceOutput o)
        {
            half4 c = texCUBE(_ColorMap, IN.localNormal);
            o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap));
            o.Albedo = c.rgb;
        }
        ENDCG
    } 
    Fallback "Diffuse"
}
