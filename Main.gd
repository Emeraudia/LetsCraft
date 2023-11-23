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

# Called when the node enters the scene tree for the first time.
func _ready():
	var scene_gestion_piece = load("res://gestion_piece/GestionPiece.tscn")
	var instance_gestion_piece = scene_gestion_piece.instantiate()
	add_child(instance_gestion_piece)
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	selection_mode()
	
	
	


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



func reset_mode():
	mode = SelectionMode.Off
	translate = TranslationMode.Off
	creation = CreationMode.Off
