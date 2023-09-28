extends Node3D

var step = 0.05

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Input.is_action_just_pressed("anchor")):
		anchor_modif($ObjetListe.scale)
		
func anchor_modif(piece_size):
	var anchor = load("res://anchor.tscn")
	var i = 0
	var j = 0
	while(i*(step) <= piece_size.y/2):
		var child = anchor.instantiate()
		child.position = Vector3(-0.5,i,0)
		$AnchorListe.add_child(child)
		i = i+step
	
	
	


