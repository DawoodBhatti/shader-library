shader_type spatial;
render_mode unshaded, cull_disabled, blend_add;

uniform float explosion_time = 0.0;
uniform float explosion_size = 1.0;
uniform float dissolve_amount : hint_range(0.0, 1.0) = 0.0;
uniform float swirl_strength : hint_range(0.0, 3.0) = 1.2;
uniform float shock_strength : hint_range(0.0, 1.0) = 0.4;
uniform vec3 color_core = vec3(1.0, 0.6, 0.2);
uniform vec3 color_outer = vec3(0.2, 0.6, 1.0);

varying vec3 world_pos;
varying vec3 obj_pos;
varying vec3 normal_dir;

void vertex() {
    world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
    obj_pos = VERTEX;
    normal_dir = NORMAL;
}

// Simple FBM noise
float hash(vec3 p) {
    p = fract(p * 0.3183099 + vec3(0.1, 0.2, 0.3));
    p *= 17.0;
    return fract(p.x * p.y * p.z * (p.x + p.y + p.z));
}

float noise(vec3 p) {
    vec3 i = floor(p);
    vec3 f = fract(p);
    float n = 0.0;
    for (int x = 0; x < 2; x++)
    for (int y = 0; y < 2; y++)
    for (int z = 0; z < 2; z++) {
        vec3 o = vec3(float(x), float(y), float(z)); // ✅ cast to float
        float h = hash(i + o);
        float w = dot(f - o, f - o);
        n += mix(h, 1.0 - h, w);
    }
    return n * 0.125;
}


void fragment() {
    // Explosion expansion
    float radius = explosion_size * (0.5 + explosion_time * 2.0);
    float dist = length(obj_pos) / radius;

    // Swirl distortion
    vec3 swirl_p = obj_pos;
    float swirl = sin(swirl_p.y * 8.0 + TIME * 6.0) * swirl_strength;
	mat2 swirl_mat = mat2(
	    vec2(cos(swirl), -sin(swirl)),
	    vec2(sin(swirl),  cos(swirl))
	);
	swirl_p.xz = swirl_mat * swirl_p.xz;
	
    // Noise dissolve
    float n = noise(swirl_p * 3.0 + TIME * 1.5);
    float dissolve = smoothstep(dissolve_amount, dissolve_amount + 0.2, n);

    // Shockwave ring
    float shock = sin(dist * 20.0 - explosion_time * 25.0) * shock_strength;
    shock *= exp(-dist * 2.0);

    // Color
    float fres = pow(1.0 - abs(dot(normalize(VIEW), normal_dir)), 3.0);
    vec3 col = mix(color_core, color_outer, dist + shock + fres);

    ALBEDO = col;
    ALPHA = dissolve * (1.0 - dist);
}
