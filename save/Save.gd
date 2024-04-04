extends Node

signal select
@export var path_to_save : String
# Called when the node enters the scene tree for the first time.
func _ready():
	# path to the save on the system
	path_to_save = OS.get_user_data_dir() + "/save/"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


# Note: This can be called from anywhere inside the tree. This function is
# path independent.
# Go through everything in the Persist group and ask them to return a
# dict of relevant variables.
# if no file name is provide, use the name "lastSave"
func save_piece(saveName : String = "lastSave"):
	
	if not DirAccess.dir_exists_absolute(path_to_save):
		DirAccess.make_dir_absolute(path_to_save)

	
	var savePiece = FileAccess.open(path_to_save + saveName + ".save", FileAccess.WRITE)
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
	
	
	if not FileAccess.file_exists(path_to_save + saveName + ".save"):
		print(path_to_save + saveName + ".save")
		print( saveName + " doesn't exist")
		return # Error! We don't have a save to load.

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	var savePiece = FileAccess.open((path_to_save + saveName + ".save"), FileAccess.READ)
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
		new_object.clicked.connect(get_node("/root/main/GestionPiece").select_piece)
		new_object.add_to_group("Persist")
		
	print("file loaded : " + saveName)
	
		# Now we set the remaining variables. Pas utilise pour les pieces pour le moment
		#for i in node_data.keys():
			#if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
				#continue
			#new_object.set(i, node_data[i])



# Note: This can be called from anywhere inside the tree. This function
# is path independent.
# if no file name is provide, use the name "lastSave"
# same as load_piece but without signal and without output in the consol
func load_demo(parentNode: String, saveName : String = "lastSave"):
	
	
	if not FileAccess.file_exists(path_to_save + saveName + ".save"):
		return # Error! We don't have a save to load.

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	var savePiece = FileAccess.open((path_to_save + saveName + ".save"), FileAccess.READ)
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
