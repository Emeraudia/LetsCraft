extends Node

#differents types de selection
#Multi : selection possible de plusieurs pieces
#Only : selection max de 1 piece
enum SelectionMode {
	Off,
	Area,
	Multi,
	Only,
}

enum TranslationMode {
	Off,
	Plan,
	Profondeur,
}

var uiFocus = false

var pieceClicked = false
var mode = SelectionMode.Off
var translate = TranslationMode.Off
var dragDist = 0
var mouseOrigin = Vector3(0,0,0)
var mousePosOnClick = Vector2(0,0)
var mouseCurrentPos = Vector2(0,0)
var listSelection = Array()
# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("piece/Area3D").clicked.connect(select_piece)
	
	get_node("piece2/Area3D").clicked.connect(select_piece)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# selection_mode()
	
	#selection
	if(Input.is_action_pressed("click_gauche") && pieceClicked == false && mode != SelectionMode.Off && !uiFocus):
		unselectAll()
	elif(Input.is_action_pressed("click_gauche")):
		pieceClicked = false
	for i in listSelection:
		i.get_child(0).change_color(Color(1, 1, 0, 1.0))
	#mouvement
	if(Input.is_action_just_pressed("click_gauche")):
		mousePosOnClick = get_viewport().get_mouse_position()
	
	if(!listSelection.is_empty() && Input.is_action_pressed("click_gauche") && translate != TranslationMode.Off):
		
		if(translate == TranslationMode.Plan):
		
			mouseCurrentPos = get_viewport().get_mouse_position()
			
			if(Input.is_action_just_pressed("click_gauche")):
				dragDist = $Camera3D.get_camera_transform().origin.distance_to(listSelection[-1].get_child(0).origin)
				mouseOrigin = $Camera3D.project_position(
					mouseCurrentPos, 
					dragDist
				)
				print(mouseOrigin)
			
			var mouseCurrentPosGlobal = $Camera3D.project_position(mouseCurrentPos,dragDist) - mouseOrigin

			var camera_transform = $Camera3D.get_camera_transform()
			var camera_rotation = camera_transform.basis
			var movement = (camera_rotation * mouseCurrentPosGlobal)
			for i in listSelection:
				i.get_child(0).setPos(movement)
			mouseOrigin = $Camera3D.project_position(
				mouseCurrentPos, 
				dragDist
			)
			#print(mousePosOnClick.x-mouseCurrentPos.x,mousePosOnClick.y-mouseCurrentPos.y)
		
		


#selection de la methode de selection des pieces
func selection_mode():
	if (Input.is_action_pressed("B")):
		reset_mode()
		mode = SelectionMode.Multi
	elif (Input.is_action_pressed("N")):
		reset_mode()
		mode = SelectionMode.Only
	elif(Input.is_action_pressed("Plan")):
		reset_mode()
		translate = TranslationMode.Plan
	elif(Input.is_action_pressed("Profondeur")):
		reset_mode()
		translate = TranslationMode.Profondeur

#recupere la derniere piece cliquer et l'ajoute a la liste de selection en fonction du mode
func select_piece(node):
	pieceClicked = true
	if (mode == SelectionMode.Multi  && listSelection.find(node) == -1):
		listSelection.append(node)
	elif(mode == SelectionMode.Only):
		unselectAll()
		listSelection.append(node)

#deselectionne toutes les pieces
func unselectAll():
	for i in listSelection:
		i.get_child(0).change_color(Color(0.42, 0.69, 0.13, 1.0))
	listSelection.clear()

func reset_mode():
	mode = SelectionMode.Off
	translate = TranslationMode.Off

func _on_editor_option_button(index):
	reset_mode()
	match index:
		0:
			mode = SelectionMode.Only
		1:
			mode = SelectionMode.Multi
		2:
			translate = TranslationMode.Plan




func _on_editor_mouse_entered():
	uiFocus = false

func _on_editor_mouse_exited():
	uiFocus = true
