extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Input.is_action_just_pressed("anchor")):
		anchor_modif($ObjetListe.scale)
	if(Input.is_action_just_pressed("resize")):
		resize()
		
func anchor_modif(piece_size):
	for decay in $AnchorListe.get_children():
		decay.queue_free()
		
	var anchor = load("res://create_bloc/anchor.tscn")
	var y = piece_size.y
	var z = piece_size.z
	for k in [-1,1]:
		for i in [-1,1]:
			for j in [-1,1]:
				var child = anchor.instantiate()
				child.position = Vector3(k*piece_size.x/2,i*piece_size.y/2,j*piece_size.z/2)
				$AnchorListe.add_child(child)
	
func resize():
	$ObjetListe.scale = Vector3(randf_range(0.5,1.5),randf_range(0.5,1.5),randf_range(0.5,1.5))
	anchor_modif($ObjetListe.scale)
	
	
	


