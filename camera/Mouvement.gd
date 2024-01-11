extends Node3D

@export var camera : Camera3D

var speed = 0.25
var zoom_speed = 5
var translation_speed = 1;
var translation_mouvement = Vector3.ZERO;
var origin = Vector3(0,0,0)
var distance = 5
var rot = Vector3()
var delta_time = 0.0
func _ready():
	pass


func _input(event):
	# State check
	if(State.get_editor_mode() != State.EditorMode.Camera):
		return
	
	if input_translate_camera(event):
		pass
	elif input_zoom_camera(event):
		if event.get_button_index() == MouseButton.MOUSE_BUTTON_WHEEL_DOWN:
			distance += delta_time * zoom_speed
		elif event.get_button_index() == MouseButton.MOUSE_BUTTON_WHEEL_UP:
			distance -= delta_time * zoom_speed
			distance = max(0, distance)
	elif input_rotate_camera(event):
		rot.x += event.relative.y * speed * delta_time
		rot.y -= event.relative.x * speed * delta_time
		rot.x = min(rot.x, (PI-0.001) / 2.0)
		rot.x = max(rot.x, (-PI+0.001) / 2.0)

func _process(delta):
	delta_time = delta
	camera.position = origin + Quaternion.from_euler(rot) * Vector3(0, 0, -distance)
	camera.transform = camera.transform.looking_at(origin)

func input_rotate_camera(event) -> bool:
	return \
		(event is InputEventMouseMotion and\
			Input.is_action_pressed("click_gauche")) or \
		event is InputEventScreenDrag

func input_translate_camera(event):
	return (event is InputEventMouseMotion and \
				Input.is_action_pressed("click_gauche") and \
				Input.is_key_pressed(KEY_SHIFT))

func input_zoom_camera(event):
	return event is InputEventMouseButton and \
		(event.get_button_index() == MouseButton.MOUSE_BUTTON_WHEEL_DOWN or \
		event.get_button_index() == MouseButton.MOUSE_BUTTON_WHEEL_UP)
