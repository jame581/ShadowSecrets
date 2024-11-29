shader_type canvas_item;

uniform sampler2D mask: filter_nearest ;

uniform vec4 enabled_color : source_color = vec4(0.0, 1.0, 0.0, 1.0); // Green color

void fragment() {
    vec4 texture_color = texture(TEXTURE, UV);
    vec4 mask_color = texture(mask, UV);

    // Further reduce the flash value to make the flashing more subtle
    float flash = 0.75 * abs(sin(TIME * 5.0));
    vec4 target_color = mix(texture_color, enabled_color, flash);
    vec4 mask_colored =  mix(mask_color, target_color, mask_color);

   	vec4 final_color = mix(texture_color, mask_colored, mask_color.a);

    COLOR = final_color;
}