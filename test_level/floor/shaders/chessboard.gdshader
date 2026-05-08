shader_type spatial;
render_mode blend_mix, cull_disabled, depth_draw_opaque;

//varying value is a value which we calculate within the vertex() function and used inside the fragment() function
//but crucially whose value is interpolated by the GPU
varying vec3 v_world_pos;

uniform vec4 color_1 : source_color;
uniform vec4 color_2 : source_color;

//area of solid colour indicating floor collision shape 
uniform int solid_floor_length;

//area of grid lines 
uniform int visible_floor_length;

//total number of squares appearing on shape are: squares * squares
uniform int squares;

//enforce integer sizing from gdscript as can't draw non integer pixels
uniform float square_length;


void vertex() {

    //world matrix transform is contained in model_matrix and allows us to convert from local to world space.
    //when we multiply it by an object's local co-ordinate we obtain that object's world coordinates
    v_world_pos = (MODEL_MATRIX  * vec4(VERTEX, 1.0)).xyz;
}


void fragment() {

    //UV coordinates represent the normalised 0-1 coordinates
    // so we need to multiply by the shape length
    vec2 scaled = UV * float(visible_floor_length);
    float half_length = float(solid_floor_length)/2.0;

    //bounds of collision floor plane
    float x_lower = 0.5 * float(visible_floor_length) - half_length;
    float x_upper = 0.5 * float(visible_floor_length) + half_length;
    float y_lower = x_lower;
    float y_upper = x_upper;

    vec4 colour;


    //paint collision floor plane
    if ((scaled.x) > x_lower && (scaled.x) < x_upper && 
        (scaled.y) > y_lower && (scaled.y) < y_upper){

        int nx = int((ceil((scaled.x-x_lower)/square_length)));
        int ny = int((ceil((scaled.y-y_lower)/square_length)));

        //set colour even squares (turqoise)
        colour = color_2;

        //set colour odd squares (mustard)
        //it turns out that to get the checkerboard pattern we need find the sum of the row+col integer and choose either odd or even!
        if ((nx+ny) % 2 == 1){ 
            colour = color_1;  
        }

       //col = vec4(0.1, 0.1, 1.0, 0.5);

    //paint non collidable floor plane as fading grid lines
    }else{
        //default colour
        colour = vec4(1.0, 1.0, 1.0, 0.0);

        //we use fwidth to solve anti aliasing flicker of grid lines
        float gx = mod(scaled.x + square_length/2.0, square_length);
        float gy = mod(scaled.y + square_length/2.0, square_length);

        //fwidth takes a distance function and computes the sum of absolute derivatives across neighbours in a 2 by 2 grid
        //it corresponds to the 'footprint' of a 2d pixel projected into our 3d game space
        float px = fwidth(scaled.x);
        float py = fwidth(scaled.y);

        if (gx < px || gy < py) {
            colour = vec4(0.0, 0.0, 0.0, 0.3);

            //similar to WORLD_MATRIX... INV_VIEW_MATRIX converts from camera space to world space. so when we multiply by the camera's position (local origin) in its own frame of 
            //reference we obtain its position in world space. 
            vec3 world_pos  = v_world_pos;

            //note the .xyz at the end is syntax for extracting only some of the components of the vec4 and we call this 'swizzling'
            vec3 camera_pos = (INV_VIEW_MATRIX * vec4(0.0, 0.0, 0.0, 1.0)).xyz;

            // distance of fragment to camera
            float dist = distance(world_pos, camera_pos);

            // tune these
            float fade_start = 100.0;
            float fade_end   = 300.0;

            float fade = clamp(1.0 - (dist - fade_start) / (fade_end - fade_start), 0.0, 1.0);
            colour.a *= fade;
        }

    }

    ALBEDO = colour.rgb;
    ALPHA = colour.a;

}

// void fragment() {
//     ALBEDO = vec3(UV.x, UV.y, 0.0);
//     ALPHA = 1.0;
// }