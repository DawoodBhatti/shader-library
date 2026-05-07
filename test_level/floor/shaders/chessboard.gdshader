shader_type spatial;
render_mode blend_mix, cull_disabled, depth_draw_opaque;

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

    //grid line width
    float grid_width = 1.1;

    vec4 colour;


    //paint collision floor plane
    if ((scaled.x) > x_lower + grid_width && (scaled.x) < x_upper && 
        (scaled.y) > y_lower + grid_width && (scaled.y) < y_upper){

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


    //paint non collidable floor plane
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
        }

    }

    ALBEDO = colour.rgb;
    ALPHA = colour.a;

}

// void fragment() {
//     ALBEDO = vec3(UV.x, UV.y, 0.0);
//     ALPHA = 1.0;
// }