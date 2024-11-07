shader_type canvas_item;

uniform sampler2D mask;
uniform vec4 tint_color: source_color = vec4(0.0, 1.0, 0.0, 1.0);
uniform float enabled;

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 mask_color = texture(mask, UV);
	vec4 tex_color = texture(TEXTURE, UV);
	vec4 tinted_mask = mask_color * tint_color;
	float intensity = mask_color.a * enabled * 0.65;

	COLOR = mix(tex_color, tinted_mask, intensity);
}