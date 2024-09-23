shader_type spatial;

uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : repeat_enable;

void fragment() {
	vec2 base_uv = UV;
	vec4 albedo_texture = texture(texture_albedo, base_uv);
	albedo_texture *= COLOR;
	ALBEDO = albedo.rgb * albedo_texture.rgb;
}
