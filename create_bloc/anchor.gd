extends Area3D
var s = Vector3(0.03,0.03,0.03)


var newMaterial = StandardMaterial3D.new()
var newMesh = BoxMesh.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	newMaterial.albedo_color = Color(0.64, 0, 0.65, 1.0)
	newMesh.material = newMaterial
	$MeshInstance3D.mesh = newMesh
	$CollisionShape3D.get_shape().set_size(s)
	$MeshInstance3D.get_mesh().set_size(s)



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
	


func _on_area_entered(area):
	if(get_parent().get_parent() != area.get_parent().get_parent()):
		print("OwO")
