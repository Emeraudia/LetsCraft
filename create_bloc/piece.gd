extends Node3D
signal clicked(node) #signal emit when you click on the object

var enter = false
var origin = position
var newMaterial = StandardMaterial3D.new()
var newMesh = BoxMesh.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	newMaterial.albedo_color = Color(0.42, 0.69, 0.13, 1.0)
	$ObjetListe/Obj/Mesh.mesh = newMesh
	for obj in $ObjetListe.get_children() :
		obj.get_child(0).material_override = newMaterial


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Input.is_action_just_pressed("anchor")):
		var sp = get_pos_size()
		anchor_modif(sp[0],sp[1])
		antene_modif(sp[0],sp[1])
	if(Input.is_action_just_pressed("resize")):
		resize()
		
	if(enter && Input.is_action_just_pressed("click_gauche")):
		emit_signal("clicked",self)
		
func anchor_modif(piece_size,pos):
	for decay in $AnchorListe.get_children():
		decay.queue_free()
	
	var anchor = load("res://create_bloc/anchor.tscn")
	var x = piece_size.x
	var y = piece_size.y
	var z = piece_size.z
	
	for i in [-1 , 1] :
		for j in [-1 , 1] :
			#4 arrete axe horizontal 
			var child = anchor.instantiate()
			child.position = Vector3(pos.x+i*x/2,pos.y,pos.z+j*z/2)
			child.change_scale(Vector3(0,y*0.95,0))
			$AnchorListe.add_child(child)
			#4 arrete axe vertical
			child = anchor.instantiate()
			child.position = Vector3(pos.x+i*x/2,pos.y+j*y/2,pos.z)
			child.change_scale(Vector3(0,0,z*0.95))
			$AnchorListe.add_child(child)
			#4 arrete axe circulaire
			child = anchor.instantiate()
			child.position = Vector3(pos.x,pos.y+i*y/2,pos.z+j*z/2)
			child.change_scale(Vector3(x*0.95,0,0))
			$AnchorListe.add_child(child)

	
func antene_modif(piece_size,pos):
	for decay in $AnteneListe.get_children():
		decay.queue_free()
	
	var antene = load("res://create_bloc/anchor.tscn")
	var x = piece_size.x
	var y = piece_size.y
	var z = piece_size.z
	
	var size = 0.5
	
	for i in [-1 , 1] :
		
		var child = antene.instantiate()
		child.position = Vector3(pos.x+i*(x/2+size/2)+0.01,pos.y+0,pos.z+0)
		child.change_scale(Vector3(size,0,0))
		$AnchorListe.add_child(child)
		
		child = antene.instantiate()
		child.position = Vector3(pos.x+0,pos.y+i*(y/2+size/2)+0.01,pos.z+0)
		child.change_scale(Vector3(0,size,0))
		$AnchorListe.add_child(child)
		
		child = antene.instantiate()
		child.position = Vector3(pos.x+0,pos.y+0,pos.z+i*(z/2+size/2)+0.01)
		child.change_scale(Vector3(0,0,size))
		$AnchorListe.add_child(child)
	
func resize():
	var size
	var pos
	for obj in $ObjetListe.get_children() :
		size = Vector3(randf_range(0.5,1.5),randf_range(0.5,1.5),randf_range(0.5,1.5))
		obj.get_child(0).get_mesh().set_size(size)
		obj.get_child(1).get_shape().set_size(size)
		
	var val = get_pos_size()
	size = val[0]
	pos = val[1]
	anchor_modif(size,pos)
	antene_modif(size,pos)
	
	
func get_pos_size():
	var min = Vector3(0,0,0)
	var max = Vector3(0,0,0)
	var size
	for obj in $ObjetListe.get_children() :
		size = obj.get_child(0).get_mesh().get_size()
		
		min.x = min(obj.position.x-size.x/2, min.x)
		min.y = min(obj.position.y-size.y/2, min.y)
		min.z = min(obj.position.z-size.z/2, min.z)
		
		max.x = max(obj.position.x+size.x/2, max.x)
		max.y = max(obj.position.y+size.y/2, max.y)
		max.z = max(obj.position.z+size.z/2, max.z)

			
	size = Vector3(max.x-min.x,max.y-min.y,max.z-min.z)
	var pos = Vector3((min.x+max.x)/2,(min.y+max.y)/2,(min.z+max.z)/2)
	
	return [size,pos]

func get_size():
	pass
	
func _on_mouse_entered():
	enter = true



func _on_mouse_exited():
	enter = false
	
#change the color of the mesh
#@param a color
func change_color(c):
	newMaterial.albedo_color = c
	for mesh in $ObjetListe.get_children() :
		mesh.get_child(0).material_override = newMaterial
	
#relocalise la piece a la positon p
func setPos(p):
	position.x = position.x+p[0]
	position.y = position.y+p[1]
	position.z = position.z+p[2]
	
	
func getPosPlan():
	return [position.x,position.y]
	


