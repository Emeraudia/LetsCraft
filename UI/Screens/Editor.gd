extends Control

signal mode

func _on_select_button_pressed():
	mode.emit("select")

func _on_move_button_pressed():
	mode.emit("move")

func _on_new_cube_button_pressed():
	#mode.emit("new")
	$ChooseElement.visible = true;
	
func _on_edit_shape_button_pressed():
	mode.emit("edit")

func _on_camera_button_pressed():
	mode.emit("camera")

func _on_choose_element_choose_element(title: String):
	print(title)
	$ChooseElement.visible = false;
