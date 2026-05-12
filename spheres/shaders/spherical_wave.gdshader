shader_type spatial;
render_mode blend_mix, cull_disabled, depth_draw_opaque;

uniform float band_width = 0.05;


void vertex() {
	// Called for every vertex the material is visible on.
	
	//distortion band travelling from north to south
	float distortion = sin(TIME + VERTEX.y);
	if (smoothstep(band_width, 0.0, abs(distortion)) > 0.0 ){
		VERTEX.x *= 1.1;
		VERTEX.z *= 1.1;
	}
}
	

//NOTES:
//UV always ranges from 0 to 1
//A sphere UV is spherical polar coords with radius set to 1, where
//U = φ / (2π)     → 0 to 1
//V = θ / π        → 0 to 1

//φ (phi) = azimuth angle around vertical (Y axis)
//θ (theta) = polar angle from the vertical (Y axis)


void fragment() {
	// Called for every pixel the material is visible on.
	float phi = UV.x * TAU;   
	float theta = UV.y * PI;
	
	float h_rings = sin(phi * 15.0 + TIME );  
	float v_rings = cos(theta * 15.0 + TIME );  

	// create banding (horizontal, vertical or both)
	if (smoothstep(band_width, 0.0, abs(h_rings)) > 0.0 || smoothstep(band_width, 0.0, abs(v_rings)) > 0.0) {
		ALBEDO = vec3(1.0, 1.0, 1.0);
		ALPHA = 1.0;
		
	}else{
		ALPHA =0.0;
	}
}


//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
