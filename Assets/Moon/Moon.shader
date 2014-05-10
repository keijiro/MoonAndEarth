Shader "Custom/Moon"
{
    Properties
    {
        _ColorMap("Color Map", CUBE) = ""{}
        _NormalMap("Normal Map", 2D) = ""{}
        _HorizonFade("Horizon Fading", Range(0.0, 10.0)) = 5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200
        
        CGPROGRAM
        #pragma surface surf Moon vertex:vert

        samplerCUBE _ColorMap;
        sampler2D _NormalMap;
        half _HorizonFade;

        half4 LightingMoon(SurfaceOutput s, half3 lightDir, half atten)
        {
            half ln = dot(lightDir, s.Normal);
            half hr = saturate(dot(lightDir, half3(0, 0, 1)) * _HorizonFade + 1);
            return half4(s.Albedo * _LightColor0.rgb * (max(0, ln) * hr * atten * 2), 1);
        }

        struct Input
        {
            float2 uv_NormalMap;
            float3 localNormal;
        };

        void vert(inout appdata_tan v, out Input o)
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
