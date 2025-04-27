shader_type canvas_item;

//toggle below on for use in inspector
//uniform vec4 selected_color : source_color; // Color picker to select the wave color
//uniform float segments ; 

//NOTE: the display in previews aren't the same as final running output... I'm not sure why. Wonder if it's because we are working with resonant effects at quite high orders of magnitude... and/or there may be some difference between the editor viewport and the final game view

void fragment() {
    vec2 screen_pos = SCREEN_UV; // Normalized screen-space coordinates
	vec4 selected_color = vec4(0.319, 0.528, 1.0, 1.0);
	float segments = 932.0 ; // experiment with this number to find pleasing patterns. 
                             // 162, 301, 327, 462 work well and 932 is around the solid resonance pattern
    float increment = 1.0 / segments;
	float width = increment / 2.0;

    // Calculate the banded section for the current pixel
	// Get integer multiples of screen_pos.y which we use to define the bands that we 
    float counter = floor(screen_pos.y / increment) * increment;

    // Compute the sine wave position
    float sin_wave_y = counter + 0.0012 * sin(TIME + screen_pos.x * 25.0 + counter*15.0);

    // Check if the fragment falls within the sine wave band
    if (abs(screen_pos.y - sin_wave_y) > (0.75 * width) && abs(screen_pos.y - sin_wave_y) < 1.25 * width) {
        COLOR = selected_color // Apply color only within the wave regions
    	     + sin(TIME)/50.0; // Small time based blue colour variation
	}
}
