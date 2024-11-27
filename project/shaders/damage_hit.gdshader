shader_type canvas_item;

global uniform float insanity = 0.0;
uniform float effect_visibility = 0.0; // control the visibility of the effect

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 texture_color = texture(TEXTURE, UV);
	vec2 uv = FRAGCOORD.xy / SCREEN_PIXEL_SIZE;
	vec2 center = vec2(0.5, 0.65);
	float dist = distance(UV, center);
	float intensity = 0.0 + smoothstep(0.0, 1.0 - insanity, dist);

	// Scale the intensity by the effect_visibility uniform
	intensity *= effect_visibility;

	COLOR = vec4(intensity, 0.0, 0.0, intensity);
}

// min 1.5
// max 0.5