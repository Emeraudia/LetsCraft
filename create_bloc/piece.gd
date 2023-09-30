extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Input.is_action_just_pressed("anchor")):
		anchor_modif($ObjetListe.scale)
		antene_modif($ObjetListe.scale)
	if(Input.is_action_just_pressed("resize")):
		resize()
		
func anchor_modif(piece_size):
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
			child.position = Vector3(i*x/2,0,j*z/2)
			child.change_scale(Vector3(0,y*0.95,0))
			$AnchorListe.add_child(child)
			#4 arrete axe vertical
			child = anchor.instantiate()
			child.position = Vector3(i*x/2,j*y/2,0)
			child.change_scale(Vector3(0,0,z*0.95))
			$AnchorListe.add_child(child)
			#4 arrete axe circulaire
			child = anchor.instantiate()
			child.position = Vector3(0,i*y/2,j*z/2)
			child.change_scale(Vector3(x*0.95,0,0))
			$AnchorListe.add_child(child)

	
func antene_modif(piece_size):
	for decay in $AnteneListe.get_children():
		decay.queue_free()
	
	var antene = load("res://create_bloc/anchor.tscn")
	var x = piece_size.x
	var y = piece_size.y
	var z = piece_size.z
	
	var size = 0.5
	
	for i in [-1 , 1] :
		
		var child = antene.instantiate()
		child.position = Vector3(i*(x/2+size/2)+0.01,0,0)
		child.change_scale(Vector3(size,0,0))
		$AnchorListe.add_child(child)
		
		child = antene.instantiate()
		child.position = Vector3(0,i*(y/2+size/2)+0.01,0)
		child.change_scale(Vector3(0,size,0))
		$AnchorListe.add_child(child)
		
		child = antene.instantiate()
		child.position = Vector3(0,0,i*(z/2+size/2)+0.01)
		child.change_scale(Vector3(0,0,size))
		$AnchorListe.add_child(child)
	
func resize():
	$ObjetListe.scale = Vector3(randf_range(0.5,1.5),randf_range(0.5,1.5),randf_range(0.5,1.5))
	anchor_modif($ObjetListe.scale)
	antene_modif($ObjetListe.scale)
	
	
	


