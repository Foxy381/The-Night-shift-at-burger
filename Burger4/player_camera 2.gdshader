shader_type spatial;
render_mode depth_prepass_alpha, ambient_light_disabled;

group_uniforms Diffuse;
uniform sampler2D fresnelRamp : hint_default_transparent;
uniform float diffuseIntensity : hint_range(0.0, 1.0) = 0.8;
uniform vec3 DiffuseColor : source_color = vec3(1);
uniform bool useReflectionMapping = false;
uniform sampler2D DiffuseTexture : filter_linear_mipmap,repeat_enable, source_color, hint_default_transparent;
uniform bool textureMode = true;
uniform float NormalMapIntensity : hint_range(0.0, 1.0) = 0.0;
uniform sampler2D NormalTexture : filter_linear_mipmap,repeat_enable, hint_normal;

group_uniforms Specular;
uniform float SpecularIntensity : hint_range(0.0, 1.0) = 0.5;
uniform sampler2D SpecularIntensityTexture : hint_roughness_r,filter_linear_mipmap,repeat_enable;
uniform float intensTexAmount : hint_range(0.0, 1.0) = 1;
uniform float Hardness : hint_range(1.0, 511.0, 1.0) = 50.0;
uniform float hardTexAmount : hint_range(0.0, 1.0) = 1;
uniform sampler2D SpecularHardnessTexture : hint_roughness_r,filter_linear_mipmap,repeat_enable;
uniform vec3 SpecularColor : source_color = vec3(1);
uniform sampler2D SpecularColorTexture : hint_roughness_r,filter_linear_mipmap,repeat_enable, source_color;
uniform float colorTexAmount : hint_range(0.0, 1.0) = 1;

group_uniforms Shading;
uniform float Emit : hint_range(0.0, 1.0) = 0.0;

group_uniforms Transparency;
uniform float alpha : hint_range(0.0, 1.0) = 1.0;
uniform sampler2D alphaTexture;

vec4 fresnel(vec3 normal, vec3 view) {
	float fresnel = (1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0 ));
	return texture(fresnelRamp, (vec2(-fresnel)-vec2(0.01)) );
}

vec3 reflectionVector(vec3 normal){
	normal *= vec3(1,-1,-1);
	vec3 asd = reflect(vec3(0,0,1), normal);
	vec3 reflection = asd+vec3(1,1,0)*.5;

	return reflection;
}

void fragment() {
	vec3 normal = mix(vec3(0.5, 0.5, 1.0), texture(NormalTexture, UV).rgb, vec3(NormalMapIntensity, NormalMapIntensity, NormalMapIntensity));
	NORMAL_MAP = normal;
	float alphaTex = texture(alphaTexture, UV).a;
	ALPHA = alpha*alphaTex;
}

void light() {
	float finalSpecularIntensity = SpecularIntensity * mix(1.0, texture(SpecularIntensityTexture, UV).r, intensTexAmount);
	float finalSpecularHard = Hardness*mix(1.0, texture(SpecularHardnessTexture, UV).r, hardTexAmount);

	vec3 L = normalize(LIGHT);
	vec3 N = normalize(NORMAL);

	float NdotL = dot(N, L)*ATTENUATION;
	float diffuse = max(NdotL, 0.0)*diffuseIntensity;
	vec4 fresnel = fresnel(NORMAL, VIEW);
	vec4 diffuseTex = texture( DiffuseTexture, mix(UV, reflectionVector(NORMAL).rg, float(useReflectionMapping) ) );

	vec3 multiplyByTex = DiffuseColor * diffuseTex.rgb;
	vec3 overlayTex = mix(DiffuseColor, diffuseTex.rgb, diffuseTex.a);

	vec3 diffuseFinalColor = mix( mix( multiplyByTex, overlayTex, vec3( float(textureMode) ) ), fresnel.rgb, fresnel.a );
	vec3 finalDiffuse = (vec3(diffuse, diffuse, diffuse) * (LIGHT_COLOR/vec3(PI)) * diffuseFinalColor);

	vec3 specColorTex = mix(vec3(1.0, 1.0, 1.0), texture(SpecularColorTexture, UV).rgb, vec3(colorTexAmount, colorTexAmount, colorTexAmount));
	vec3 V = normalize(VIEW);
	vec3 H = normalize(L + V);

	float specular = max(pow(dot(H, NORMAL), finalSpecularHard), 0.0)*finalSpecularIntensity;
	vec3 finalSpecColor = SpecularColor * specColorTex;
	vec3 finalSpecular = ( (vec3(specular)*finalSpecColor)*(LIGHT_COLOR/vec3(3)) ) * max(1.-pow(1.-NdotL, 20), 0.0);

	SPECULAR_LIGHT = finalSpecular + SPECULAR_LIGHT;
	DIFFUSE_LIGHT = (finalDiffuse+(vec3(Emit)*diffuseFinalColor)) + DIFFUSE_LIGHT;
}