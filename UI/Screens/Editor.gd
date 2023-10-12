extends Control

signal mode

func _on_select_button_pressed():
	mode.emit("select")


func _on_move_button_pressed():
	mode.emit("move")
