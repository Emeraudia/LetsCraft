extends Area3D
signal clicked(node) #signal emit when you click on the object

var enter = false
var origin = position
var newMaterial = StandardMaterial3D.new()
# Called when the node enters the scene tree for the first time.
#put green color by default to the mesh
func _ready():
	newMaterial.albedo_color = Color(0.42, 0.69, 0.13, 1.0)
	$mesh.material_override = newMaterial
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(enter && Input.is_action_pressed("click_gauche")):
		emit_signal("clicked",get_parent())

func _on_mouse_entered():
	enter = true


func _on_mouse_exited():
	enter = false
	
#change the color of the mesh
#@param a color
func change_color(c):
	newMaterial.albedo_color = c
	$mesh.material_override = newMaterial
	
#relocalise la piece a la positon p
func setPos(p):
	position.x = position.x+p[0]
	position.y = position.y+p[1]
	position.z = position.z+p[2]
	
	
func getPosPlan():
	return [position.x,position.y]
	
