extends Control

signal optionButton

func _on_option_button_item_selected(index):
	optionButton.emit(index)
