shader_type canvas_item;

uniform sampler2D mask;
uniform sampler2D face : filter_nearest;
uniform float transition : hint_range(0.0, 1.0);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 original_color = texture(TEXTURE, UV);
	vec4 face_color = texture(face, UV);
	COLOR = mix(original_color, face_color, transition);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
