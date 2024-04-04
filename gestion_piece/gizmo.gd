class_name Gizmo
extends Node3D

@export var overX = false
@export var overY = false
@export var overZ = false

func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_x_mouse_entered():
	overX = true

func _on_area_x_mouse_exited():
	overX = false

func _on_area_z_mouse_entered():
	overZ = true
	
func _on_area_z_mouse_exited():
	overZ = false

func _on_area_y_mouse_entered():
	overY = true
	
func _on_area_y_mouse_exited():
	overY = false
