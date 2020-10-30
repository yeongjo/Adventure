// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Custom/CustomShadow" {
  Properties
     {
         _Color ("Color", Color) = (1.0,1.0,1.0,1.0)
         _MainTexture("MainTexture", 2D) = "white" {}
          _ShadowColor ("Color", Color) = (1.0,1.0,1.0,1.0)
          _AmbientAmount ("AmbientAmount", Float ) = 1.0
     }
     
     CGINCLUDE
     #include "UnityCG.cginc"
     #include "AutoLight.cginc"
     #include "Lighting.cginc"
     ENDCG
 
  SubShader
  {
      LOD 200
      Tags { "RenderType"="Opaque" }
      Pass { 
             Lighting On
             Tags {"LightMode" = "ForwardBase"}
             CGPROGRAM
             #pragma vertex vert
             #pragma fragment frag
             #pragma multi_compile_fwdbase
 
             uniform half4        _Color;
             uniform half4 _ShadowColor;
             uniform sampler2D _MainTexture;
             uniform float _AmbientAmount;
 
             struct vertexInput
             {
                 half4     vertex        :    POSITION;
                 half3     normal        :    NORMAL;
                 float2 uv:TEXCOORD0;
             };
             
             struct vertexOutput
             {
                 half4     pos                :    SV_POSITION;
                 fixed4     lightDirection    :    TEXCOORD1;
                 fixed3     viewDirection    :    TEXCOORD2;
                 fixed3     normalWorld        :    TEXCOORD3;
                 float2 uv:TEXCOORD;
                 LIGHTING_COORDS(4,6)
             };

             float4 _MainTexture_ST;
 
              vertexOutput vert (vertexInput v)
             {
                 vertexOutput o;
                 
                 half4 posWorld = mul( unity_ObjectToWorld, v.vertex );
                 o.normalWorld = normalize( mul(half4(v.normal, 0.0), unity_WorldToObject).xyz );
                 o.pos = UnityObjectToClipPos(v.vertex);
                 o.viewDirection = normalize(_WorldSpaceCameraPos.xyz - posWorld.xyz);
                 o.uv = TRANSFORM_TEX(v.uv, _MainTexture);
             
                 TRANSFER_VERTEX_TO_FRAGMENT(o);
                 
                 return o;
             }
             
             half4 frag (vertexOutput i) : COLOR
             {
                 fixed NdotL = dot(i.normalWorld, i.lightDirection);
                 half atten = LIGHT_ATTENUATION(i);
                 fixed3 diffuseReflection = tex2D(_MainTexture, i.uv)*_LightColor0.rgb * atten * _Color.rgb + tex2D(_MainTexture, i.uv)*(1-atten)*_ShadowColor;
                 fixed3 finalColor = UNITY_LIGHTMODEL_AMBIENT.xyz * _AmbientAmount + diffuseReflection;
                 
                 return float4(finalColor, _Color.a);
             }
             
              ENDCG
          }
      }
      FallBack "Diffuse"
  }