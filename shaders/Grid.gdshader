shader_type spatial;
render_mode cull_disabled;
render_mode unshaded;

uniform float lineWidth = 0.02;
uniform float gridSize = 10.0;

float dist(float value, float width){
	return smoothstep(width, width / 2., value) + smoothstep(1. - (width), 1. - (width / 2.), value);
}

float grid(vec2 uv, float columns, float rows){
	vec2 f = fract(vec2(uv.x * columns, uv.y * rows));
	return dist(f.x, lineWidth) + dist(f.y, lineWidth);
}

void fragment() {
    float grid = grid(UV, gridSize, gridSize);


	ALBEDO = vec3(1.0, 1.0, 1.0);
	ALPHA = (grid) * (1.0 - (distance(UV, vec2(0.5)) * 2.0)) ;
    
}
