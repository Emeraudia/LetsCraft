extends Node3D

@export var doRotate = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(doRotate):
		self.rotate(Vector3(0,1,0),0.01)
