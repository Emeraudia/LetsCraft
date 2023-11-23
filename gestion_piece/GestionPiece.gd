extends Node3D

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
func _process(delta):
	get_node("PieceList/Piece").clicked.connect(select_piece)
	
	#Creation d'une piece
	if(creation != CreationMode.Off && Input.is_action_just_pressed("click_gauche")):
		var scene = load("res://gestion_piece/create_bloc/piece.tscn")
		var instance = scene.instantiate()
		
		#coordonnees de la souris dans l'espace 3D par rapport à l'origine 
		dragDist = $Camera3D.get_camera_transform().origin.distance_to(Vector3(0,0,0)) #origine du repère
		mouseCurrentPos = get_viewport().get_mouse_position()
		mouseOrigin = $Camera3D.project_position(mouseCurrentPos, dragDist)
		
		instance.setPos(mouseOrigin)
		get_child(2).add_child(instance)
		instance.clicked.connect(select_piece)

	
	
	#mouvement
	if(!listSelection.is_empty() && Input.is_action_pressed("click_gauche") && translate != TranslationMode.Off):
		
		if(translate == TranslationMode.Plan):
			
			
			
			mouseCurrentPos = get_viewport().get_mouse_position()
			
			if(Input.is_action_just_pressed("click_gauche")):
				dragDist = $Camera3D.get_camera_transform().origin.distance_to(listSelection[-1].origin)
				mouseOrigin = $Camera3D.project_position(
					mouseCurrentPos, 
					dragDist
				)
			
			var mouseCurrentPosGlobal = $Camera3D.project_position(mouseCurrentPos,dragDist) - mouseOrigin

			var camera_transform = $Camera3D.get_camera_transform()
			var camera_rotaton = camera_transform.basis
			var movement = (camera_rotation * mouseCurrentPosGlobal)
			for i in listSelection:
				i.setPos(movement)
				mouseOrigin = $Camera3D.project_position(
				mouseCurrentPos, 
				dragDist
			)
	

#recupere la derniere piece cliquer et l'ajoute a la liste de selection en fonction du mode
func select_piece(node):
	if(mode == SelectionMode.On):
		if(listSelection.find(node) == -1):
			node.change_color(Color(1, 1, 0, 1.0))
			listSelection.append(node)
		else:
			deselect_piece(node)	

func deselect_piece(node):
	listSelection.remove_at(listSelection.find(node))
	node.change_color(Color(0.42, 0.69, 0.13, 1.0))
			
#deselectionne toutes les pieces
func unselectAll():
	for i in listSelection:
		i.change_color(Color(0.42, 0.69, 0.13, 1.0))
	listSelection.clear()


