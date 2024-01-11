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
	instance.add_to_group("Persist") #on l'ajoute au group persist afin de la sauvegarder

#permet de bouger les pieces selectionnees
#le mouvement est relative au premier clique de la souris
#ne prend pas de parametres, ne renvoie rien
func move_pieces():
	
	mouseCurrentPos = get_viewport().get_mouse_position()
		
	if(Input.is_action_just_pressed("click_gauche")):
		dragDist = node_camera.get_camera_transform().origin.distance_to(listSelection[-1].origin)
		mouseOrigin = node_camera.project_position(mouseCurrentPos, dragDist)
	
	var mouseCurrentPosGlobal = node_camera.project_position(mouseCurrentPos,dragDist) - mouseOrigin
	
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

# Note: This can be called from anywhere inside the tree. This function is
# path independent.
# Go through everything in the Persist group and ask them to return a
# dict of relevant variables.
# if no file name is provide, use the name "lastSave"

func save_piece(saveName : String = "lastSave"):
	

	var savePiece = FileAccess.open("user://save/" + saveName + ".save", FileAccess.WRITE)
	var saveNodes = get_tree().get_nodes_in_group("Persist")
	for node in saveNodes:
		# Check the node is an instanced scene so it can be instanced again during load.
		if node.scene_file_path.is_empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		# Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function.
		var node_data = node.call("save")

		# JSON provides a static method to serialized JSON string.
		var json_string = JSON.stringify(node_data)

		# Store the save dictionary as a new line in the save file.
		savePiece.store_line(json_string)
	
	print("file saved : " + saveName)
		
# Note: This can be called from anywhere inside the tree. This function
# is path independent.
# if no file name is provide, use the name "lastSave"
func load_piece(parentNode: String, saveName : String = "lastSave"):
	
	
	if not FileAccess.file_exists("user://save/" + saveName + ".save"):
		print( saveName + " doesn't exist")
		return # Error! We don't have a save to load.

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	var savePiece = FileAccess.open(("user://save/" + saveName + ".save"), FileAccess.READ)
	while savePiece.get_position() < savePiece.get_length():
		var json_string = savePiece.get_line()

		# Creates the helper class to interact with JSON
		var json = JSON.new()

		# Check if there is any error while parsing the JSON string, skip in case of failure
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		# Get the data from the JSON object
		var node_data = json.get_data()

		# Firstly, we need to create the object and add it to the tree and set its position.
		var new_object = load(node_data["filename"]).instantiate()
		get_node(parentNode).add_child(new_object)
		new_object.setPos(Vector3(node_data["pos_x"], node_data["pos_y"],node_data["pos_z"]))
		new_object.clicked.connect(select_piece)
		new_object.add_to_group("Persist")
		
	print("file loaded : " + saveName)
	
		# Now we set the remaining variables. Pas utilise pour les pieces pour le moment
		#for i in node_data.keys():
			#if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
				#continue
			#new_object.set(i, node_data[i])
