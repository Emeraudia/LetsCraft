extends Control

signal chooseElement

var saves = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_card_pressed(eventType, title):
	if(eventType == Card.Event.PRESSED):
		chooseElement.emit(title)

# get all the save files and store them in a var
func update_save_dir():
	
	# si le dossier save n'existe pas, on le creer
	var dir = DirAccess.open("user://")
	if (!dir.dir_exists("user://save")):
		dir.make_dir("user://save")
	
	# on recupere toutes les saves
	dir = DirAccess.open("user://save")
	saves = dir.get_files()
	
	# enleve l'extension au nom de la sauvegarde
	for i in range(saves.size()):
		saves[i] = saves[i].left(saves[i].length()-5)

# creer une card et l'ajoute a la node
func create_cards(title: String):
	
	var card = load("res://UI/Components/Card.tscn").instantiate() # Charge la scene, l'instancie
	card.setTitle(title) # Lui donne un titre
	card.name = title # Donne un nom a la node
	get_node("ScrollContainer/MarginContainer/HFlowContainer").add_child(card) # Ajoute la node

# supprime toutes les cards non associes a une save
func remove_cards():
	
	for i in get_node("ScrollContainer/MarginContainer/HFlowContainer").get_children():
		i.disconnect("cardEvent", _on_card_pressed)
		i.queue_free()



func update():
	
	remove_cards()
	update_save_dir() # mise a jour des saves
	
	for i in saves:
		create_cards(i)
	
	for N in $ScrollContainer/MarginContainer/HFlowContainer.get_children():
		N.connect("cardEvent", _on_card_pressed)
		
