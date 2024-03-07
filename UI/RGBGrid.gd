extends MeshInstance3D

var hue: float;

# Called when the node enters the scene tree for the first time.
func _ready():
	hue = 0;
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	hue = (hue + 0.01)
	if(hue > 1):
		hue = 0

	self.material_override.set_shader_parameter("color", Color.from_hsv (hue, 1.0, 1.0));

