shader_type canvas_item;
render_mode blend_mix;

uniform float max_distance = 100.0; // Maximum distance for full transparency

void fragment() {
    vec4 texture_color = texture(TEXTURE, UV);
    
    // Get the center of the viewport in screen UV coordinates
    vec2 viewport_center = vec2(0.5, 0.5);
    
    // Calculate the distance from the current pixel to the center of the viewport
    float distance = distance(SCREEN_UV, viewport_center);
    
    // Calculate the alpha value based on the distance
    float alpha = clamp(1.0 - (distance / max_distance), 0.0, 1.0);
    
    // Set the final color with the calculated alpha
    COLOR = vec4(texture_color.rgb, texture_color.a * alpha);
}