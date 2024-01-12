extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	
	#instancie la classe gestion_piece et l'ajoute en temps qu'enfant au main
	var scene_gestion_piece = preload("res://gestion_piece/GestionPiece.tscn")
	var instance_gestion_piece = scene_gestion_piece.instantiate()
	add_child(instance_gestion_piece)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	selection_mode()

# Gestion des input pour les raccourcis clavier
func selection_mode():
	if (Input.is_action_pressed("selection")): # key b selection mode
		State.set_editor_mode(State.EditorMode.Selection)
	elif(Input.is_action_pressed("mouvement")): # key o pour activer le mouvement des pieces 
		State.set_editor_mode(State.EditorMode.Translation)
	elif(Input.is_action_pressed("Create")): #key c and left click to create a piece
		State.set_editor_mode(State.EditorMode.Creation)
	elif(Input.is_action_just_pressed("delete")): #key backspace pour supprimer la selection
		$GestionPiece.delete_pieces()
	elif(Input.is_action_just_pressed("save")): #key ctr+s save the piece's list
		Save.save_piece()
	elif(Input.is_action_just_pressed("load")): #key ctr+l load the last save (fast load)
		Save.load_piece("/root/main/GestionPiece/PieceListe")

# Gestion des inputs via l'UI
func _on_editor_mode(x,y):
	if x=="move" :
		State.set_editor_mode(State.EditorMode.Translation)
	
	if x=="select" :
		State.set_editor_mode(State.EditorMode.Selection)
		
	if x=="new" :
		State.set_editor_mode(State.EditorMode.Creation)
		
	if x=="edit" :
		Input.action_press("resize")
		
	if x=="camera":
		State.set_editor_mode(State.EditorMode.Camera)
		
	if x=="load":
		Save.load_piece("/root/main/GestionPiece/PieceListe", y)
