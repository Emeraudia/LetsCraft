extends PanelContainer
class_name Card

signal cardEvent

enum Event { PRESSED }

@export var title : String

func _ready():
	$MarginContainer/Label.text = title


func _on_sub_viewport_tree_entered():
	$SubViewportContainer/SubViewport.render_target_update_mode = 1


func _on_mouse_entered():
	$SubViewportContainer/SubViewport/Model.doRotate = true
	$SubViewportContainer/SubViewport.render_target_update_mode = 4


func _on_mouse_exited():
	$SubViewportContainer/SubViewport/Model.doRotate = false
	$SubViewportContainer/SubViewport.render_target_update_mode = 0


func _on_gui_input(event):
	if event.is_pressed():
		cardEvent.emit(Event.PRESSED, title)

func setTitle(newTitle: String):
	title = newTitle

