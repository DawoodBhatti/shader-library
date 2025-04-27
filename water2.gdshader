shader_type canvas_item;

void fragment() {
    vec2 screen_pos = SCREEN_UV; // Global screen-space coordinates

    // First Harmonic Wave (Deep Blue)
    float wave1 = sin(screen_pos.x + TIME * 1.5);
    float y_position1 = screen_pos.y - 0.45;
    float line1 = smoothstep(-0.02, 0.02, wave1 * 0.01 - y_position1);
    vec3 color1 = mix(vec3(0.1, 0.3, 0.66), vec3(0.4, 0.6, 1.0), line1);

    // Second Harmonic Wave (Turquoise)
    float wave2 = sin(screen_pos.x * 9.0 + TIME * 1.2) * cos(screen_pos.x * 4.0) 
                + 1.3 * sin(screen_pos.x * 6.0) 
                * cos(screen_pos.x - 3.0) 
                * sin(screen_pos.x * 2.5);
    float y_position2 = screen_pos.y - 0.5;
    float line2 = smoothstep(-0.02, 0.02, wave2 * 0.12 - y_position2);
    vec3 color2 = mix(vec3(0.0, 0.08, 0.47), vec3(0.3, 1.0, 0.9), line2);

    // Third Wave (Exponential-based Motion, Lighter Blue)
    float wave3 = exp(sin(screen_pos.x * 4.0 + TIME * 2.0) * 0.5) - 1.0;
    float y_position3 = screen_pos.y - 0.5;
    float line3 = smoothstep(-0.02, 0.02, wave3 * 0.1 - y_position3);
    vec3 color3 = mix(vec3(0.2, 0.4, 0.9), vec3(0.5, 0.7, 1.0), line3);

    // Blend All Three Waves
    vec3 final_color = mix(color1, color2, 0.4);
    final_color = mix(final_color, color3, 0.3);

    COLOR = vec4(final_color, 0.7);
}
