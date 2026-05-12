shader_type canvas_item;

// Declare a varying variable to pass color from vertex to fragment shader
varying vec4 vertex_color;

// Vertex shader function
void vertex() {
    // Use the vertex position to create dynamic color changes
    float transformed_sin = 0.5 * (sin(VERTEX.x + TIME*TIME*0.3) + 1.0);
    float transformed_cos = 0.5 * (cos(VERTEX.y + TIME*TIME*0.3) + 1.0);

    // Use the transformed values to create a yellow gradient
    vertex_color = vec4(1.0, 1.0, transformed_sin, transformed_cos); // Yellow shades
}

void fragment() {
	// Use TIME to create dynamic color changes
	//float time = TIME; // Elapsed time in seconds

	// Transform trig functions to vary between 0 and 1
	//float transformed_cos = 0.5 * (cos(time) + 1.0);
	//float transformed_sin = 0.5 * (sin(time) + 1.0);

	// Use TIME to create dynamic color changes
	//vec4 dynamic_color = vec4(transformed_sin, transformed_cos, transformed_cos, transformed_sin);

	// Sample the sprite's texture
    vec4 pixel_color = texture(TEXTURE, UV);

	// Combine the dynamic color with the sprite's color
	COLOR = pixel_color * vertex_color;
}