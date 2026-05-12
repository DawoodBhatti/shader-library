shader_type spatial;
render_mode blend_mix, cull_disabled, depth_draw_opaque;

// interpolated world position
varying vec3 v_world_pos;

uniform vec4 color_1 : source_color;
uniform vec4 color_2 : source_color;

uniform int solid_floor_length;
uniform int visible_floor_length;
uniform int squares;
uniform float square_length;


// ------------------------------------------------------------
// Helper: IQ palette
// ------------------------------------------------------------
vec3 palette(float t) {
    vec3 a = vec3(0.5);
    vec3 b = vec3(0.5);
    vec3 c = vec3(1.0);
    vec3 d = vec3(0.263, 0.416, 0.557);
    return a + b * cos(6.28318 * (c * t + d));
}


// ------------------------------------------------------------
// Vertex
// ------------------------------------------------------------
void vertex() {
    v_world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}


// ------------------------------------------------------------
// Fragment
// ------------------------------------------------------------
void fragment() {

    // scale UV into grid space
    vec2 scaled = UV * float(visible_floor_length);
    float half_len = float(solid_floor_length) * 0.5;

    // collision square bounds
    float x_lower = 0.5 * float(visible_floor_length) - half_len;
    float x_upper = 0.5 * float(visible_floor_length) + half_len;
    float y_lower = x_lower;
    float y_upper = x_upper;

    // final output colour
    vec3 final_rgb = vec3(0.0);
    float final_a = 1.0;


    // --------------------------------------------------------
    // COLLISION AREA — neon procedural pattern
    // --------------------------------------------------------
    if (scaled.x > x_lower && scaled.x < x_upper &&
        scaled.y > y_lower && scaled.y < y_upper) {

        vec2 nUV;
        nUV.x = (scaled.x - x_lower) / float(solid_floor_length);
        nUV.y = (scaled.y - y_lower) / float(solid_floor_length);

        // centre to [-1,1]
        nUV = (nUV - 0.5) * 2.0;

        vec2 nUV0 = nUV;

        // repeated neon rings
        for (float i = 0.0; i < 3.0; i++) {

            nUV = fract(nUV * 1.3) - 0.5;

            float d = length(nUV) * exp(-length(nUV0));

            vec3 col = palette(length(nUV0) + i * 0.3 + TIME * 0.3);

            d = abs(sin(d * 8.0 + TIME));
            d = 0.01 / d;   // neon inverse glow

            final_rgb += col * d;
        }

        final_a = 1.0;
    }


    // --------------------------------------------------------
    // NON-COLLISION AREA — fading grid lines
    // --------------------------------------------------------
    else {

        final_rgb = vec3(1.0);
        final_a = 0.0;

        float gx = mod(scaled.x + square_length * 0.5, square_length);
        float gy = mod(scaled.y + square_length * 0.5, square_length);

        float px = fwidth(scaled.x);
        float py = fwidth(scaled.y);

        if (gx < px || gy < py) {

            final_rgb = vec3(0.0);
            final_a = 0.3;

            vec3 world_pos  = v_world_pos;
            vec3 camera_pos = (INV_VIEW_MATRIX * vec4(0.0, 0.0, 0.0, 1.0)).xyz;

            float dist = distance(world_pos, camera_pos);

            float fade_start = 100.0;
            float fade_end   = 300.0;

            float fade = clamp(1.0 - (dist - fade_start) / (fade_end - fade_start), 0.0, 1.0);
            final_a *= fade;
        }
    }


    // --------------------------------------------------------
    // Output
    // --------------------------------------------------------
    ALBEDO = final_rgb;
    ALPHA  = final_a;
}
