extends Area3D
var s = Vector3(0.03,0.03,0.03)

# Called when the node enters the scene tree for the first time.
func _ready():
	scale = s


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func change_scale(vScale) :
	var x = s
	var y = s
	var z = s
	if(vScale.x != 0) : 
		s.x = vScale.x
	if(vScale.y != 0) : 
		s.y = vScale.y
	if(vScale.z != 0) : 
		s.z = vScale.z
