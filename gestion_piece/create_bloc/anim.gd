extends Node3D

@export var doRotate = false

func _ready():
	Save.load_demo(self.get_path(), get_parent().get_parent().get_parent().title)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(doRotate):
		self.rotate(Vector3(0,1,0),0.01)
