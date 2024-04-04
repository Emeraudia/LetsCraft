extends Node

enum EditorMode {
	Selection,
	Translation,
	Creation,
	Camera
}

enum View {ABSORB,SELECT}

enum InputMode {ACTIVATE, DEACTIVATE}

var inputMode : InputMode
var editorMode:EditorMode

func _ready():
	set_editor_mode(EditorMode.Selection)
	set_input_mode(InputMode.ACTIVATE)


func _process(_delta):
	pass

func set_editor_mode(mode:EditorMode):
	editorMode = mode

func get_editor_mode() -> EditorMode:
	return editorMode

func set_input_mode(mode : InputMode):
	inputMode = mode

func get_input_mode() -> InputMode:
	return inputMode
