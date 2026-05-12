shader_type canvas_item;

//use water4 as it's better. 
void fragment() {
    vec2 screen_pos = SCREEN_UV; // Normalized screen-space coordinates
	vec4 selected_color = vec4(0.319, 0.528, 1.0, 1.0);
	float segments = 932.0 ; // experiment with this number to find pleasing patterns. 
                             // 162, 301, 327, 462 work well and 932 is around the solid resonance pattern
    float increment = 1.0 / segments;
    float width = increment / 1.1;

    // Calculate the banded section for the current pixel
    float counter = floor(screen_pos.y / increment) * increment;

    // Compute the sine wave position
    float sin_wave_y = counter + 0.1 * ( sin(TIME + screen_pos.x * 26.0 + counter));

    // Check if the fragment falls within the sine wave band
    if (abs(screen_pos.y - sin_wave_y) > (0.9 * width) && abs(screen_pos.y - sin_wave_y) < 1.1 * width) {
        COLOR = selected_color // Apply color only within the wave regions
    	     + sin(TIME)/50.0; // Small blue colour variation
	}
}
