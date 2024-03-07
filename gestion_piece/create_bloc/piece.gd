extends Node3D
signal clicked(node) #signal emit when you click on the object

var origin = position
var newMaterial = StandardMaterial3D.new()
var newMesh = BoxMesh.new()

enum FaceList {L,R,F,B,D,U,NONE}
var FaceSelect = FaceList.NONE


# Called when the node enters the scene tree for the first time.
func _ready():
	newMaterial.albedo_color = Color(0.42, 0.69, 0.13, 1.0)
	$ObjetListe/Obj/Mesh.mesh = newMesh
	for obj in $ObjetListe.get_children() :
		obj.get_child(0).material_override = newMaterial

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	print(FaceSelect)

func _on_mouse_exited():
	FaceSelect = FaceList.NONE
func _on_mouse_entered(extra_arg_0):
	FaceSelect = FaceList.keys()[extra_arg_0]
	
func getImage():
	var subNode = $ObjetListe/Obj/Mesh
	return subNode
