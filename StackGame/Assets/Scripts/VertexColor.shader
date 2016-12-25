Shader "VertexColor" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
	}
	SubShader {
		Pass{
		Lighting On
		ColorMaterial AmbientAndDiffuse
		SetTexture[_MainTex]{
		combine texture * primary DOUBLE
		}
    }
	}
	}