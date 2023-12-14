extends Control

signal chooseElement

# Called when the node enters the scene tree for the first time.
func _ready():
	for N in $ScrollContainer/MarginContainer/HFlowContainer.get_children():
		N.connect("cardEvent", _on_card_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_card_pressed(eventType, title):
	if(eventType == Card.Event.PRESSED):
		chooseElement.emit(title)
