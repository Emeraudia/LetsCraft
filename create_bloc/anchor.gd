extends Area3D
var s = Vector3(0.03,0.03,0.03)

var newMaterial = StandardMaterial3D.new()
var newMesh = BoxMesh.new()

var contrainte_dim
var contrainte_way = 1
var disable = false

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
	if(!disable and get_parent().get_parent() != area.get_parent().get_parent()):
		disable = true
		get_parent().get_parent().addContrainte(area.get_parent().get_parent(),contrainte_dim,contrainte_way)


func _on_area_exited(area):
	if(get_parent().get_parent() != area.get_parent().get_parent()):
		disable = false
		get_parent().get_parent().removeContrainte(area.get_parent().get_parent())
