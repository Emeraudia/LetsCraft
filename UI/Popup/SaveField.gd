extends Control

signal text

var actualText : String

func _on_line_edit_text_submitted(new_text):
	text.emit(new_text)
	State.set_input_mode(State.InputMode.ACTIVATE)


func _on_button_pressed():
	visible = false
	State.set_input_mode(State.InputMode.ACTIVATE)


func _on_validate_button_pressed():
	text.emit(actualText)
	State.set_input_mode(State.InputMode.ACTIVATE)


func _on_line_edit_text_changed(new_text):
	actualText = new_text
