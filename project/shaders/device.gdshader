shader_type canvas_item;

uniform sampler2D mask: filter_nearest ;
uniform vec4 disabled_color : source_color = vec4(1.0, 0.0, 0.0, 1.0); // Red color
uniform vec4 enabled_color : source_color = vec4(0.0, 1.0, 0.0, 1.0); // Green color

uniform float enabled : hint_range(0.0, 1.0);

void fragment() {
    vec4 texture_color = texture(TEXTURE, UV);
    vec4 mask_color = texture(mask, UV);

    vec4 target_color = mix(disabled_color, enabled_color, enabled);
    vec4 mask_colored =  mix(mask_color, target_color, mask_color);

   	vec4 final_color = mix(texture_color, mask_colored, mask_color.a);

    COLOR = final_color;
}