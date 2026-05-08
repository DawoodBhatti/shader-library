shader_type spatial;
render_mode blend_mix, cull_disabled, depth_draw_opaque;


//area of solid colour indicating floor collision shape 
uniform int solid_floor_length;

//area of grid lines 
uniform int visible_floor_length;

//helper functions need to be defined before they are called in code
//https://iquilezles.org/articles/palettes/
vec3 palette( float t ) {
    vec3 a = vec3(0.5, 0.5, 0.5);
    vec3 b = vec3(0.5, 0.5, 0.5);
    vec3 c = vec3(1.0, 1.0, 1.0);
    vec3 d = vec3(0.263,0.416,0.557);

    return a + b*cos( 6.28318*(c*t+d) );
}

void vertex() {
	// Called for every vertex the material is visible on.
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

    vec4 colour = vec4(1.0, 1.0, 1.0, 0.5);
	vec3 final_colour = vec3(0.0);

    //paint collision floor plane
	if (scaled.x > x_lower && scaled.x < x_upper &&
		scaled.y > y_lower && scaled.y < y_upper) {


		vec2 nUV = vec2(0.0,0.0);

		//calculate normalised UV x and y components for the inner square
		nUV.x = (scaled.x - x_lower) / float(solid_floor_length);
		nUV.y = (scaled.y - y_lower) / float(solid_floor_length);

		//shift coordinate space so that center of world space corresponds to the center of the canvs
		nUV = (nUV-0.5)*2.0;

		//shadow original normalised UV to use the original d value to break local repetition of colour gradient
		vec2 nUV0 = nUV;

		//use for loop to add repetitions of this pattern

		for (float i = 0.0; i<3.0; i++){
			//create repeated tiling and shift them to center
			//break symmetry by multiplying by some number other than 2.0 and introduce more visual interest
			nUV = fract(nUV * 1.3)-0.5;
			
			//multiply d by some exponential function to increase variation further
			float d = length(nUV) * exp(-length(nUV0));

			//add variations to colour as a function of time and loop level
			vec3 colour = palette(length(nUV0) + i *.3 + TIME*.3);

			d = sin(d * 8. + TIME);
			d = abs(d);

			//d = step(0.1, d);
			//d = smoothstep(0.0, 0.1, d);

			//inverse of d for neon colouring
			d = 0.01/d;
			final_colour += colour * d;
		}

		ALBEDO = vec3(final_colour);
		ALPHA = 1.0;
	}

}


