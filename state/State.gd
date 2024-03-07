extends Node

enum EditorMode {
	Selection,
	Translation,
	Creation,
	Modification,
	Camera
}

enum View {ABSORB,SELECT}

var editorMode:EditorMode

func _ready():
	set_editor_mode(EditorMode.Selection)


func _process(_delta):
	pass

func set_editor_mode(mode:EditorMode):
	editorMode = mode

func get_editor_mode() -> EditorMode:
	return editorMode
