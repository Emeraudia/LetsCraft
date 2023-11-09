extends Control

signal mode

func _on_select_button_pressed():
	mode.emit("select")


func _on_move_button_pressed():
	mode.emit("move")

func _on_new_cube_button_pressed():
	mode.emit("new")

func _on_edit_shape_button_pressed():
	mode.emit("edit")
