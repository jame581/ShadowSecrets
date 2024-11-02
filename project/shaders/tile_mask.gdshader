shader_type canvas_item;

uniform sampler2D mask; // The mask texture
uniform vec4 tint_color: source_color = vec4(0.0, 1.0, 0.0, 1.0); // The color to tint with
uniform float pulse_speed; // Speed of the pulsing effect

void fragment() {
    // Get the color from the mask texture at the current UV coordinates
    vec4 mask_color = texture(mask, UV);
    // Get the color from the main texture at the current UV coordinates
    vec4 texture_color = texture(TEXTURE, UV);
    // Calculate the pulsing intensity using a sine wave
    float intensity = ((sin(TIME*pulse_speed) + 1.0) / 2.0);  
    // Blend the original texture color with the modulated tint color
    vec4 color = mix(texture_color, tint_color, intensity);
    // Use the mask to determine where to apply the blended color
    COLOR = mix(texture_color, color, mask_color.r);
}