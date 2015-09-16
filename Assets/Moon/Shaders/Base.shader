Shader "Moon/Base"
{
    Properties
    {
        _BaseMap ("Base Map", CUBE) = ""{}
        _Saturation ("Saturation", Range(0,2)) = 1

        _NormalMap ("Normal Map", 2D) = ""{}
        _NormalScale ("Normal Scale", Range(0,2)) = 0.5

        _Glossiness ("Smoothness", Range(0,1)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM

        #pragma surface surf Standard vertex:vert nolightmap addshadow
        #pragma target 3.0

        samplerCUBE _BaseMap;
        half _Saturation;

        sampler2D _NormalMap;
        half _NormalScale;

        half _Glossiness;

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

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            half4 base = texCUBE(_BaseMap, IN.localNormal);
            half4 normal = tex2D(_NormalMap, IN.uv_NormalMap);

            o.Albedo = lerp((float3)Luminance(base), base.rgb, _Saturation);
            o.Normal = UnpackScaleNormal(normal, _NormalScale);
            o.Smoothness = _Glossiness;

            o.Metallic = 0;
            o.Alpha = 1;
        }

        ENDCG
    }
    FallBack "Diffuse"
}
