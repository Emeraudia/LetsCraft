extends Node

#differents types de selection
#Multi : selection possible de plusieurs pieces
#Only : selection max de 1 piece
enum SelectionMode {
	Off,
	On,
}

enum TranslationMode {
	Off,
	Plan,
	Profondeur,
}
enum CreationMode {
	Off,
	On,
}

var mode = SelectionMode.On
var translate = TranslationMode.Off
var creation = CreationMode.Off
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
	
	
	#Creation d'une piece
	if(creation != CreationMode.Off && Input.is_action_just_pressed("click_gauche")):
		print("Piece créer")
		var scene = load("res://create_bloc/piece.tscn")
		var instance = scene.instantiate()
		instance.setPos([-2,0,0])
		add_child(instance)
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
		reset_mode()
		mode = SelectionMode.On
	elif(Input.is_action_pressed("mouvement")): # key o pour activer le mouvement des pieces 
		reset_mode()
		translate = TranslationMode.Plan
	elif(Input.is_action_pressed("Create")): #key c and left click to create a piece
		reset_mode()
		creation = CreationMode.On

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

func reset_mode():
	mode = SelectionMode.Off
	translate = TranslationMode.Off
	creation = CreationMode.Off
