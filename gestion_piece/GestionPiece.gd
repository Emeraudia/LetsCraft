extends Node3D

var pieceNb = 1
var dragDist = 0
var mouseOrigin = Vector3(0,0,0)
var mousePosOnClick = Vector2(0,0)
var mouseCurrentPos = Vector2(0,0)
var listSelection = Array()
var node_camera

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("PieceListe/Piece").clicked.connect(select_piece)
	
	#recupere la camera du viewport actif (normalement y en a qu'un et il est dans le main pour l'instant)
	node_camera = get_parent().get_viewport().get_camera_3d()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	#creation de piece
	#si on est en mode creation et que l'on fait un clique gauche
	#on creer un piece
	if(State.get_editor_mode() == State.EditorMode.Creation 
		&& Input.is_action_just_pressed("click_gauche")):
			
		create_piece()
	
	#mouvement des pieces
	#si la liste de selection n'est pas vide, que l'on fait un clique gauche et que l'on est sur le mode mouvement
	#alors on peux bouger la piece
	if(!listSelection.is_empty() 
		&& Input.is_action_pressed("click_gauche") 
		&& State.get_editor_mode() == State.EditorMode.Translation):
			
		move_pieces()



#fonction de creation d'une piece
#ne prend pas de parametre et ne renvoie rien
#creer la piece a l'endroit clicke
func create_piece():
	
	var scene = load("res://gestion_piece/create_bloc/piece.tscn")
	var instance = scene.instantiate()
	
	#coordonnees de la souris dans l'espace 3D par rapport à l'origine 
	dragDist = node_camera.get_camera_transform().origin.distance_to(Vector3(0,0,0)) #origine du repère
	mouseCurrentPos = get_viewport().get_mouse_position()
	mouseOrigin = node_camera.project_position(mouseCurrentPos, dragDist)
	
	instance.setPos(mouseOrigin)
	get_node("PieceListe").add_child(instance)
	instance.clicked.connect(select_piece)

#permet de bouger les pieces selectionnees
#le mouvement est relative au premier clique de la souris
#ne prend pas de parametres, ne renvoie rien
func move_pieces():
	
	mouseCurrentPos = get_viewport().get_mouse_position()
		
	if(Input.is_action_just_pressed("click_gauche")):
		dragDist = node_camera.get_camera_transform().origin.distance_to(listSelection[-1].origin)
		mouseOrigin = node_camera.project_position(mouseCurrentPos, dragDist)
	
	var mouseCurrentPosGlobal = node_camera.project_position(mouseCurrentPos,dragDist) - mouseOrigin
	var camera_transform = node_camera.get_camera_transform()
	
	#on fait bouger toutes les pieces de la selection
	for i in listSelection:
		i.setPos(mouseCurrentPosGlobal)
	
	mouseOrigin = node_camera.project_position(mouseCurrentPos, dragDist)


#recupere la derniere piece cliquer et l'ajoute a la liste de selection
#est appele lorsqu'elle recoit le signal "clicked" provenant de Piece.gd
func select_piece(node):
	if(State.get_editor_mode() == State.EditorMode.Selection):
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

#supprime toutes les pieces de la selection
func delete_pieces():
	
	for i in listSelection.size():
		listSelection.pop_front().queue_free()

