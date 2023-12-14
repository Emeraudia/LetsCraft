extends Node3D
signal clicked(node) #signal emit when you click on the object

var enter = false
var origin = position
var newMaterial = StandardMaterial3D.new()
var newMesh = BoxMesh.new()

# [pieces contraintes,..]
var contrainte_list = []
var canAbsorb = false
var select = false

enum CONTRAINTE_POSITION {bottom,left,up,right}
var cr_p = CONTRAINTE_POSITION.bottom




# Called when the node enters the scene tree for the first time.
func _ready():
	newMaterial.albedo_color = Color(0.42, 0.69, 0.13, 1.0)
	$ObjetListe/Obj/Mesh.mesh = newMesh
	for obj in $ObjetListe.get_children() :
		obj.get_child(0).material_override = newMaterial


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(Input.is_action_just_pressed("anchor")):
		var sp = get_pos_size()
		#anchor_modif(sp[1],sp[0])
		antene_modif(sp[1],sp[0])
	if(Input.is_action_just_pressed("resize")):
		resize()
		
	if(enter && Input.is_action_just_pressed("click_gauche")):
		emit_signal("clicked",self)
		
	var parent = get_parent().get_parent()
	match(parent.Piece_VIEW):
		State.View.ABSORB:
			_seeAbsorb()
		State.View.SELECT:
			_seeSelect()
	
		
func anchor_modif(piece_size,pos):
	for decay in $AnchorListe.get_children():
		decay.queue_free()
	
	var anchor = load("res://gestion_piece/create_bloc/anchor.tscn")
	var x = piece_size.x
	var y = piece_size.y
	var z = piece_size.z
	
	for i in [-1 , 1] :
		for j in [-1 , 1] :
			#4 arrete axe horizontal 
			var child = anchor.instantiate()
			child.position = Vector3(pos.x+i*x/2,pos.y,pos.z+j*z/2)
			child.change_scale(Vector3(0,y*0.95,0))
			child.set_collision_layer_value(1,false)
			child.set_collision_mask_value(1,false)
			child.set_collision_layer_value(2,true)
			child.set_collision_mask_value(2,true)
			$AnchorListe.add_child(child)
			#4 arrete axe vertical
			child = anchor.instantiate()
			child.position = Vector3(pos.x+i*x/2,pos.y+j*y/2,pos.z)
			child.change_scale(Vector3(0,0,z*0.95))
			child.set_collision_layer_value(1,false)
			child.set_collision_mask_value(1,false)
			child.set_collision_layer_value(2,true)
			child.set_collision_mask_value(2,true)
			$AnchorListe.add_child(child)
			#4 arrete axe circulaire
			child = anchor.instantiate()
			child.position = Vector3(pos.x,pos.y+i*y/2,pos.z+j*z/2)
			child.change_scale(Vector3(x*0.95,0,0))
			child.set_collision_layer_value(1,false)
			child.set_collision_mask_value(1,false)
			child.set_collision_layer_value(2,true)
			child.set_collision_mask_value(2,true)
			$AnchorListe.add_child(child)

	
func antene_modif(piece_size,pos):
	for decay in $AnteneListe.get_children():
		decay.queue_free()
	
	var antene = load("res://gestion_piece/create_bloc/anchor.tscn")
	var x = piece_size.x
	var y = piece_size.y
	var z = piece_size.z
	
	var size = 0.5
	
	for i in [-1 , 1] :
		
		var child = antene.instantiate()
		child.position = Vector3(pos.x+i*(x/2+size/2)+0.01,pos.y+0,pos.z+0)
		child.change_scale(Vector3(size,0,0))
		child.contrainte_dim = 0
		child.contrainte_way = i
		child.set_collision_layer_value(1,false)
		child.set_collision_layer_value(2,true)
		$AnchorListe.add_child(child)
		
		child = antene.instantiate()
		child.position = Vector3(pos.x+0,pos.y+i*(y/2+size/2)+0.01,pos.z+0)
		child.change_scale(Vector3(0,size,0))
		child.contrainte_dim = 1
		child.contrainte_way = i
		child.set_collision_layer_value(1,false)
		child.set_collision_layer_value(2,true)
		$AnchorListe.add_child(child)
		
		child = antene.instantiate()
		child.position = Vector3(pos.x+0,pos.y+0,pos.z+i*(z/2+size/2)+0.01)
		child.change_scale(Vector3(0,0,size))
		child.contrainte_dim = 2
		child.contrainte_way = i
		child.set_collision_layer_value(1,false)
		child.set_collision_layer_value(2,true)
		$AnchorListe.add_child(child)
	
func resize():
	var size
	var pos
	for obj in $ObjetListe.get_children() :
		size = Vector3(randf_range(0.5,1.5),randf_range(0.5,1.5),randf_range(0.5,1.5))
		obj.get_child(0).get_mesh().set_size(size)
		obj.get_child(1).get_shape().set_size(size)
		
	var val = get_pos_size()
	pos = val[0]
	size = val[1]
	#anchor_modif(size,pos)
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
	
	return [pos,size]

	
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
func setPos(p,listeContrainteBouger = []):
	position.x = position.x+p[0]
	position.y = position.y+p[1]
	position.z = position.z+p[2]
	
	listeContrainteBouger.append(self)
	for cr in contrainte_list:
		if cr not in listeContrainteBouger:
			cr.setPos(p,listeContrainteBouger)
	
	
func getPosPlan():
	return [position.x,position.y,position.z]
	

func addContrainte(area,dim,way):
	print(self," : ",canAbsorb)
	if(!contrainte_list.has(area)):
		if(canAbsorb):
			#écarte entre les 2 pieces
			var p = Vector3()
			var dist = sqrt(pow(area.position[dim]-position[dim],2))
			var x = dist - (area.get_pos_size()[1][dim] + get_pos_size()[1][dim])/2
			p[dim] = way*(x)
			#centrage des piece selon les autres dimension
			var other_dim = [0,1,2]
			other_dim.erase(dim)
			for dim_iter in other_dim:
				p[dim_iter] = area.position[dim_iter]-position[dim_iter]
			setPos(p)
			area.absorbChild(true,[self])
		contrainte_list.append(area)
		print(contrainte_list)

func removeContrainte(area):
	contrainte_list.erase(area)
	print(contrainte_list)
	
func removeAllContrainte():
	for cr in contrainte_list:
		cr.removeContrainte(self)
		cr.absorbChild(false,[self])
		removeContrainte(cr)

func absorbChild(value = true, listAbsorb = []):
	if self not in listAbsorb and not select:
			canAbsorb = value
			listAbsorb.append(self)
			for cr in contrainte_list:
				cr.absorbChild(value,listAbsorb)
	elif select and not (value == canAbsorb):
		canAbsorb = true
		for cr in contrainte_list:
			cr.absorbChild(true,[self])


func _seeAbsorb():
	if canAbsorb:
		change_color(Color(255,0,0))
	else:
		change_color(Color(0,0,255))
		
func _seeSelect():
	if select :
		change_color(Color(1,1,0))
	else:
		change_color(Color(0.42, 0.69, 0.13))
