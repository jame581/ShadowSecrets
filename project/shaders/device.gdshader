shader_type canvas_item;

uniform sampler2D mask;
uniform vec4 tint_color: source_color = vec4(0.0, 1.0, 0.0, 1.0);
uniform float enabled;
uniform float glow_intensity = 4.0; // Add a uniform for glow intensity

void fragment() {
    // Called for every pixel the material is visible on.
    vec4 mask_color = texture(mask, UV);
    vec4 tex_color = texture(TEXTURE, UV);
    vec4 tinted_mask = mask_color * tint_color;
    float intensity = mask_color.a * enabled * 0.65;

    // Add glow effect
    vec4 glow = tinted_mask * glow_intensity;

    COLOR = mix(tex_color, glow, intensity);
}