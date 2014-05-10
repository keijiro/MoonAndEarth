Shader "Custom/Earth"
{
    Properties
    {
        _ColorMap("Color Map", CUBE) = ""{}
        _NormalMap("Normal Map", 2D) = ""{}
        _GlossMap("Gloss Map", CUBE) = ""{}
        _CloudMap("Cloud Map", CUBE) = ""{}
        _NightMap("Night Map", 2D) = ""{}

        _Gloss("Gloss", float) = 1.0
        _Specular("Specular", float) = 0.8
        _Fresnel("Fresnel", float) = 0.6

        _CloudColor("Cloud Color", Color) = (1, 1, 1, 1)
        _NightColor("Night Light", Color) = (0.5, 0.5, 0.3, 0)

        _RimColor("Rim Color", Color) = (0.5, 0.5, 0.5, 0.0)
        _RimPower("Rim Power", float) = 1.0

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
        samplerCUBE _GlossMap;
        samplerCUBE _CloudMap;
        sampler2D _NightMap;

        half _Gloss;
        half _Specular;
        half _Fresnel;

        fixed3 _CloudColor;
        fixed3 _NightColor;

        fixed3 _RimColor;
        half _RimPower;

        half _HorizonFade;

        struct Input
        {
            float2 uv_NormalMap;
            float3 localNormal;
        };

        half4 LightingMoon(SurfaceOutput s, half3 lightDir, half3 viewDir, half atten)
        {
            half3 h = normalize(lightDir + viewDir);

            half ln = dot(lightDir, s.Normal);
            half hn = max(0, dot(h, s.Normal));
            half vh = dot(viewDir, h);
            half vn = dot(viewDir, s.Normal);

            half hr = saturate(dot(lightDir, half3(0, 0, 1)) * _HorizonFade + 1);

            float f_e = pow(1 - vh, 5);
            float f = f_e + _Fresnel * (1 - f_e);

            float diff = max(0, ln) * hr;
            float spec = pow(hn, s.Specular * 128) * f * s.Gloss * hr;

            half3 rim = _RimColor * pow(1 - vn, _RimPower) * diff;
            half3 night = pow(max(0, -ln), 4) * s.Alpha * _NightColor;

            fixed4 c;
            c.rgb = (s.Albedo * _LightColor0.rgb * diff + _LightColor0.rgb * spec + rim) * (atten * 2) + night;
            c.a = s.Alpha;
            return c;
        }

        void vert(inout appdata_full v, out Input o)
        {
            UNITY_INITIALIZE_OUTPUT(Input,o);
            o.localNormal = v.normal * float3(-1, 1, 1);
        }

        void surf(Input IN, inout SurfaceOutput o)
        {
            half4 color = texCUBE(_ColorMap, IN.localNormal);
            half4 cloud = texCUBE(_CloudMap, IN.localNormal);
            o.Albedo = lerp(color.rgb, _CloudColor, cloud.r);
            o.Alpha = tex2D(_NightMap, IN.uv_NormalMap).a;
            o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap));
            o.Gloss = texCUBE(_GlossMap, IN.localNormal).a * (1 - cloud.r) * _Gloss;
            o.Specular = _Specular;
        }
        ENDCG
    } 
    Fallback "Diffuse"
}
