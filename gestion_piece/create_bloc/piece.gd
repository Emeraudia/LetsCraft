extends Node3D
signal clicked(node) #signal emit when you click on the object

var origin = position
var newMesh = BoxMesh.new()

enum FaceList {L,R,F,B,D,U,NONE}
var FaceSelect = FaceList.NONE


# Called when the node enters the scene tree for the first time.
func _ready():
	# Set the color off all edges in black
	var newMaterial = StandardMaterial3D.new()
	newMaterial.albedo_color = Color(0,0,0, 1.0)
	$ObjetListe/Obj/Mesh.mesh = newMesh
	for obj in $ObjetListe.get_children() :
		obj.get_child(0).material_override = newMaterial
		
	# Set color of all faces
	setColorFaceAll()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#print(FaceSelect)
	pass

func _on_mouse_exited():
	FaceSelect = FaceList.NONE
func _on_mouse_entered(extra_arg_0):
	FaceSelect = FaceList.keys()[extra_arg_0]
	
func getImage():
	var subNode = $ObjetListe/Obj/Mesh
	return subNode


# Set the color of 1 face, default color = (0.42, 0.69, 0.13)
func setColorFace(face,color = Color(0.42, 0.69, 0.13, 1.0)):
	assert(face in FaceList)
	if(face != "NONE"):
		var newMaterial = StandardMaterial3D.new()
		newMaterial.albedo_color = color
		var faceNode = get_node("ObjetListe/Obj/"+face)
		faceNode.get_child(1).material_override = newMaterial
	
func setColorFaceAll(color = Color(0.42, 0.69, 0.13, 1.0)):
	for face in FaceList:
		setColorFace(face,color)
