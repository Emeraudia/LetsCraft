extends Node3D

@export var camera : Camera3D

# Speed of the rotation of the camera
const ROTATE_SPEED = 0.25
# Speed of the zoom of the camera
const ZOOM_SPEED = 5

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
		
	# Drag Event
	if event is InputEventScreenDrag:
		input_drag(event)
	
	# Mouse Event
	if event is InputEventMouse:
		input_mouse(event)
	
	# Gesture Event
	if event is InputEventGesture:
		input_gesture(event)

func _process(delta):
	delta_time = delta
	camera.position = origin + Quaternion.from_euler(rot) * Vector3(0, 0, -distance)
	camera.transform = camera.transform.looking_at(origin)

# Handle mouse input for camera movements
func input_mouse(event: InputEventMouse):
	# Rotate Camera
	if event is InputEventMouseMotion and Input.is_action_pressed("click_gauche"):
		rotate_camera(event.relative.x, event.relative.y)
	
	# Zoom in
	if event is InputEventMouseButton and event.get_button_index() == MOUSE_BUTTON_WHEEL_UP:
		zoom_camera(-event.factor)
	
	# Zoom out
	if event is InputEventMouseButton and event.get_button_index() == MOUSE_BUTTON_WHEEL_DOWN:
		zoom_camera(event.factor)

# Handle screen drag event for camera movements
func input_drag(event: InputEventScreenDrag):
	rotate_camera(event.relative.x, event.relative.y)

# Handle gesture movements for caemra movements
func input_gesture(event: InputEventGesture):
	# Zoom
	if event is InputEventMagnifyGesture:
		zoom_camera((event.factor - 1) * -20)
	
	# Translate Camera
	if event is InputEventPanGesture:
		pass

# Rotate camera
# x : Relative position x on screen
# y : Relative position y on screen 
func rotate_camera(x: float, y: float) -> void:
	rot.x += y * ROTATE_SPEED * delta_time
	rot.y -= x * ROTATE_SPEED * delta_time
	rot.x = min(rot.x, (PI-0.001) / 2.0)
	rot.x = max(rot.x, (-PI+0.001) / 2.0)

# Zoom with camera
# delta : Delta of the distance from the origin
func zoom_camera(delta: float) -> void:
	distance += delta_time * ZOOM_SPEED * delta
	distance = max(0, distance)
