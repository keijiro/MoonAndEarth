Shader "Earth/Base"
{
    Properties
    {
        _BaseMap ("Base Map", CUBE) = ""{}
        _SeaColor ("Sea Color", Color) = (0, 0, 1, 0)
        _Saturation ("Saturation", Range(0,2)) = 1

        _NormalMap ("Normal Map", 2D) = ""{}
        _NormalScale ("Normal Scale", Range(0,2)) = 0.5

        _GlossMap ("Gloss Map", CUBE) = ""{}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5

        _CloudMap ("Cloud Map", CUBE) = ""{}
        _CloudColor ("Cloud Color", Color) = (1, 1, 1, 0.5)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM

        #pragma surface surf Standard vertex:vert nolightmap addshadow
        #pragma target 3.0

        samplerCUBE _BaseMap;
        half4 _SeaColor;
        half _Saturation;

        sampler2D _NormalMap;
        half _NormalScale;

        samplerCUBE _GlossMap;
        half _Glossiness;

        samplerCUBE _CloudMap;
        fixed4 _CloudColor;

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
            half3 base = texCUBE(_BaseMap, IN.localNormal).rgb;
            half4 normal = tex2D(_NormalMap, IN.uv_NormalMap);
            half gloss = texCUBE(_GlossMap, IN.localNormal).r;
            half cloud = texCUBE(_CloudMap, IN.localNormal).r;

            base = lerp((float3)Luminance(base), base, _Saturation);
            base = lerp(base, _SeaColor.rgb, gloss * _SeaColor.a);
            cloud = min(1, cloud * _CloudColor.a);

            o.Albedo = lerp(base, _CloudColor.rgb, cloud);
            o.Normal = UnpackScaleNormal(normal, _NormalScale);
            o.Smoothness = _Glossiness * gloss * (1 - cloud);

            o.Metallic = 0;
            o.Alpha = 1;
        }

        ENDCG
    }
    FallBack "Diffuse"
}
