shader_type canvas_item;
render_mode blend_mix;

uniform float effect_visibility = 0.0; // control the visibility of the effect
global uniform float insanity = 0.0;

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 texture_color = texture(TEXTURE, UV);
	
	// Remove circular effect and use height parameter
	float intensity = smoothstep(1.0 - (insanity * 3.0), 1.0, UV.y);

	// Scale the intensity by the effect_visibility uniform
	intensity *= effect_visibility;

	// Combine the red flash with the original texture color
	vec4 flash_color = vec4(intensity, 0.0, 0.0, texture_color.a * intensity);

	// Ensure the player is still visible when insanity is zero
	COLOR = mix(texture_color, flash_color, intensity);
}

// min 1.5
// max 0.5