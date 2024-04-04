extends Node3D

var pieceNb = 1
var dragDist = 0
var mouseOrigin = Vector3(0,0,0)
var mousePosOnClick = Vector2(0,0)
var mouseCurrentPos = Vector2(0,0)
var listSelection = Array()
var node_camera

var xMotion = false
var yMotion = false
var zMotion = false

var Piece_VIEW = State.View.SELECT

# Called when the node enters the scene tree for the first time.
func _ready():
	#recupere la camera du viewport actif (normalement y en a qu'un et il est dans le main pour l'instant)
	node_camera = get_parent().get_viewport().get_camera_3d()
	
	generate_default_piece()

func _unhandled_input(event):
	if(State.get_editor_mode() == State.EditorMode.Creation \
		&& Input.is_action_pressed("click_gauche")):
		create_piece()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):	
	if (State.get_input_mode() == State.InputMode.ACTIVATE):
		#mouvement des pieces
		#si la liste de selection n'est pas vide, que l'on fait un clique gauche et que l'on est sur le mode mouvement
		#alors on peux bouger la piece
		if(!listSelection.is_empty()
			&& Input.is_action_pressed("click_gauche") 
			&& State.get_editor_mode() == State.EditorMode.Translation):
			
			move_pieces()
		
		#Suppresion des contraintes 
		#les antennes sont insensibles jusqu'as ce qu'elle sorte d'une piece
		if(Input.is_action_pressed("BreakContrainte")):
			for s in listSelection:
				s.removeAllContrainte()
		if(Input.is_action_just_pressed("change_view")):
			match(Piece_VIEW):
				State.View.ABSORB:
					Piece_VIEW = State.View.SELECT
				State.View.SELECT:
					Piece_VIEW = State.View.ABSORB
		
		if(!listSelection.is_empty()):
			$Gizmo.visible = true
			update_gizmo()
			if($Gizmo.overX && Input.is_action_just_pressed("click_gauche")):
				xMotion = true
				yMotion = false
				zMotion = false
			if($Gizmo.overY && Input.is_action_just_pressed("click_gauche")):
				xMotion = false
				yMotion = true
				zMotion = false
			if($Gizmo.overZ && Input.is_action_just_pressed("click_gauche")):
				xMotion = false
				yMotion = false
				zMotion = true
		else:
			$Gizmo.visible = false
			
		if(Input.is_action_just_released("click_gauche")):
			xMotion = false
			yMotion = false
			zMotion = false
			
		if(xMotion):
			move_pieces('x')
		if(yMotion):
			move_pieces('y')
		if(zMotion):
			move_pieces('z')

func update_gizmo():
	if listSelection.size() > 0:
		var mX = 0;
		var mY = 0;
		var mZ = 0;
		for i in listSelection:
			var pos = i.global_transform.origin
			mX += pos.x
			mY += pos.y
			mZ += pos.z
		mX /= listSelection.size()
		mY /= listSelection.size()
		mZ /= listSelection.size()
		$Gizmo.global_transform.origin = Vector3(mX, mY, mZ)

#fonction de creation d'une piece
#ne prend pas de parametre et ne renvoie rien
#creer la piece a l'endroit clicke par defaut
func create_piece(mouseCoord : bool = true, x : float = 0, y : float = 0, z : float = 0):
	
	var scene = load("res://gestion_piece/create_bloc/piece.tscn")
	var instance = scene.instantiate()
	var coordinate = Vector3(0,0,0)
	if (mouseCoord): # on utilise les coordonnees de la souris
		#coordonnees de la souris dans l'espace 3D par rapport à l'origine 
		dragDist = node_camera.get_camera_transform().origin.distance_to(Vector3(0,0,0)) #origine du repère
		mouseCurrentPos = get_viewport().get_mouse_position()
		coordinate = node_camera.project_position(mouseCurrentPos, dragDist)
	else : # on utilise les coordonnees donnes
		coordinate = Vector3(x,y,z)
		
	instance.setPos(coordinate)
	get_node("PieceListe").add_child(instance)
	instance.clicked.connect(select_piece)
	instance.add_to_group("Persist") #on l'ajoute au group persist afin de la sauvegarder

#permet de bouger les pieces selectionnees
#le mouvement est relative au premier clique de la souris
#ne prend pas de parametres, ne renvoie rien
func move_pieces(axis=null):
	
	mouseCurrentPos = get_viewport().get_mouse_position()
		
	if(Input.is_action_just_pressed("click_gauche")):
		dragDist = node_camera.get_camera_transform().origin.distance_to(listSelection[-1].origin)
		mouseOrigin = node_camera.project_position(mouseCurrentPos, dragDist)
	
	var mouseCurrentPosGlobal = node_camera.project_position(mouseCurrentPos,dragDist) - mouseOrigin
	
	if axis == 'x':
		mouseCurrentPosGlobal.y = 0;
		mouseCurrentPosGlobal.z = 0;
	if axis == 'y':
		mouseCurrentPosGlobal.x = 0;
		mouseCurrentPosGlobal.z = 0;
	if axis == 'z':
		mouseCurrentPosGlobal.x = 0;
		mouseCurrentPosGlobal.y = 0;
	
	#on fait bouger toutes les pieces de la selection
	for i in listSelection:
		i.setPos(mouseCurrentPosGlobal)
	
	mouseOrigin = node_camera.project_position(mouseCurrentPos, dragDist)


#recupere la derniere piece cliquer et l'ajoute a la liste de selection
#est appele lorsqu'elle recoit le signal "clicked" provenant de Piece.gd
func select_piece(node):
	if(State.get_editor_mode() == State.EditorMode.Selection):
		if(listSelection.find(node) == -1):
			node.absorbChild()
			node.select = true
			listSelection.append(node)
		else:
			node.select = false
			node.absorbChild(false)
			deselect_piece(node)

func deselect_piece(node):
	listSelection.remove_at(listSelection.find(node))
			
#deselectionne toutes les pieces
func unselectAll():
	for i in listSelection:
		i.change_color(Color(0.42, 0.69, 0.13, 1.0))
	listSelection.clear()

#supprime toutes les pieces de la selection
func delete_pieces():
	
	for i in listSelection.size():
		var node = listSelection.pop_front()
		node.removeAllContrainte()
		node.remove_from_group("Persist")
		node.queue_free()

func select_all():
	for i in get_node("PieceListe").get_children():
		select_piece(i)


func delete_all():
	select_all()
	delete_pieces()

func generate_default_piece():
	Save.save_piece("empty")
	create_piece(false, 0,0,0)
	Save.save_piece("cube")
	delete_all()

