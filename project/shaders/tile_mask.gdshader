shader_type canvas_item;

uniform sampler2D mask;
uniform vec4 new_color;
uniform float scale;
uniform float pulse_speed;

void fragment() {
    vec4 mask_color = texture(mask, UV);
    vec4 texture_color = texture(TEXTURE, UV);
	float intensity = clamp((sin(TIME*pulse_speed) + 1.0) / 2.0, 0.2, 1);  // Pulsing intensity between 0 and 1

    if (mask_color.r > 0.5) {
		COLOR = mix(texture_color, new_color, intensity);
    } else {
        COLOR = texture_color;
    }
}