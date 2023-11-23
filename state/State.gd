extends Node

enum EditorMode {
	Selection,
	Translation,
	Creation,
	Camera
}

var editorMode:EditorMode

func _ready():
	set_editor_mode(EditorMode.Selection)


func _process(delta):
	pass

func set_editor_mode(mode:EditorMode):
	editorMode = mode

func get_editor_mode() -> EditorMode:
	return editorMode
