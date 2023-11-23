extends Node3D

@export var camera : Camera3D

var speed = 0.25
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
	# PC
	if event is InputEventMouseMotion or event is InputEventScreenDrag:
		rot.x += event.relative.y * speed * delta_time
		rot.y -= event.relative.x * speed * delta_time
		rot.x = min(rot.x, (PI-0.001) / 2.0)
		rot.x = max(rot.x, (-PI+0.001) / 2.0)

func _process(delta):
	delta_time = delta
	camera.position = origin + Quaternion.from_euler(rot) * Vector3(0, 0, -distance)
	camera.transform = camera.transform.looking_at(origin)
