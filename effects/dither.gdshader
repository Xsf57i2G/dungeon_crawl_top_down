shader_type spatial;

uniform sampler2D map;
uniform float strength = 0.1;
uniform float depth = 3.0;

void light() {
	float light = max(0.0, dot(NORMAL, LIGHT)) * ATTENUATION;
	vec2 ts = vec2(textureSize(map, 0));
	vec2 uv = mod(floor(FRAGCOORD.xy), ts) / ts;
	light += (texture(map, uv).r - 0.5) * strength;
	light = round(light * depth) / depth;
	DIFFUSE_LIGHT += light * ALBEDO * LIGHT_COLOR;
}