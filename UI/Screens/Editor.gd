extends Control

signal mode()

func _on_select_button_pressed():
	mode.emit("select","null")

func _on_move_button_pressed():
	mode.emit("move","null")

func _on_new_cube_button_pressed():
	$ChooseElement.update_save_dir()
	$ChooseElement.update()
	$ChooseElement.visible = true;

	
func _on_edit_shape_button_pressed():
	mode.emit("edit","null")

func _on_camera_button_pressed():
	mode.emit("camera","null")

func _on_choose_element_choose_element(title: String):
	mode.emit("load",title)
	$ChooseElement.visible = false;
