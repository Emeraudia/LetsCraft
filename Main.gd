extends Node

var editor
var pieceNb = 1
var dragDist = 0
var mouseOrigin = Vector3(0,0,0)
var mousePosOnClick = Vector2(0,0)
var mouseCurrentPos = Vector2(0,0)
var listSelection = Array()
# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Piece").clicked.connect(select_piece)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	selection_mode()
	
	# Creation d'une piece
	if(State.get_editor_mode() == State.EditorMode.Creation 
		&& Input.is_action_just_pressed("click_gauche")):
		var scene = load("res://create_bloc/piece.tscn")
		var instance = scene.instantiate()
		instance.setPos([-2,0,0])
		add_child(instance)
		instance.clicked.connect(select_piece)

	# Mouvement
	if(!listSelection.is_empty() 
		&& Input.is_action_pressed("click_gauche") 
		&& State.get_editor_mode() == State.EditorMode.Translation):
		
		mouseCurrentPos = get_viewport().get_mouse_position()
		
		if(Input.is_action_just_pressed("click_gauche")):
			dragDist = $Camera3D.get_camera_transform().origin.distance_to(listSelection[-1].origin)
			mouseOrigin = $Camera3D.project_position(
				mouseCurrentPos, 
				dragDist
			)
			
		var mouseCurrentPosGlobal = $Camera3D.project_position(mouseCurrentPos,dragDist) - mouseOrigin

		var camera_transform = $Camera3D.get_camera_transform()
		var camera_rotation = camera_transform.basis
		var movement = (camera_rotation * mouseCurrentPosGlobal)
		for i in listSelection:
			i.setPos(movement)
			
		mouseOrigin = $Camera3D.project_position(
			mouseCurrentPos, 
			dragDist
		)

#selection de la methode de selection des pieces
func selection_mode():
	if (Input.is_action_pressed("selection")): # key b selection mode
		State.set_editor_mode(State.EditorMode.Selection)
	elif(Input.is_action_pressed("mouvement")): # key o pour activer le mouvement des pieces 
		State.set_editor_mode(State.EditorMode.Translation)
	elif(Input.is_action_pressed("Create")): #key c and left click to create a piece
		State.set_editor_mode(State.EditorMode.Creation)


func _on_editor_mode(x):
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
