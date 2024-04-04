shader_type spatial;
render_mode cull_disabled;
render_mode unshaded;

uniform float lineWidth = 0.02;
uniform float gridSize = 10.0;

bool clip(float value, float width){
	return value < width/2.0 || value >= 1.0 - (width/2.0);
}

bool grid(vec2 uv, float columns, float rows){
	vec2 f = fract(vec2(uv.x * columns, uv.y * rows));
	return clip(f.x, lineWidth) || clip(f.y, lineWidth);
}

void fragment() {
    bool grid = grid(UV, gridSize, gridSize);

	if(grid){
		ALBEDO = vec3(1.0, 1.0, 1.0);
		ALPHA = 1.0 - (distance(UV, vec2(0.5)) * 2.0);
	}else{
		ALBEDO = vec3(0.0, 0.0, 0.0);
		ALPHA = 0.0;
	}
    
}
