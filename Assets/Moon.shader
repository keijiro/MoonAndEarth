Shader "Custom/Moon"
{
    Properties
    {
        _Cube("Cubemap", CUBE) = ""{}
        _Bump("Bumpmap", 2D) = "bump"{}
        _RimColor("Rim Color", Color) = (0.5, 0.5, 0.5, 0.0)
        _RimPower("Rim Power", float) = 1.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200
        
        CGPROGRAM
        #pragma surface surf Moon vertex:vert

        samplerCUBE _Cube;
        sampler2D _Bump;
        float4 _RimColor;
        float _RimPower;

        struct Input
        {
            float2 uv_Bump;
            float3 localNormal;
            float3 viewDir;
        };

        half4 LightingMoon(SurfaceOutput s, half3 lightDir, half atten)
        {
            half nl = dot(s.Normal, lightDir);
            half3 rim = _RimColor.rgb * s.Alpha * pow(nl, _RimPower);
            half4 c;
            c.rgb = s.Albedo * _LightColor0.rgb * (saturate(nl) + rim) * atten * 2;
            return c;
        }

        void vert(inout appdata_full v, out Input o)
        {
            UNITY_INITIALIZE_OUTPUT(Input,o);
            o.localNormal = v.normal * float3(-1, 1, 1);
        }

        void surf(Input IN, inout SurfaceOutput o)
        {
            half4 c = texCUBE(_Cube, IN.localNormal);
            o.Normal = UnpackNormal(tex2D(_Bump, IN.uv_Bump));
            half rim = 1.0 - saturate(dot(normalize(IN.viewDir), o.Normal));
            o.Albedo = c.rgb;
            o.Alpha = pow(rim, _RimPower);
        }
        ENDCG
    } 
    Fallback "Diffuse"
}
