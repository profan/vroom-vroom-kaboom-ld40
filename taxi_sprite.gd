tool
extends Sprite

var Direction = load("res://taxi.gd").Direction

func _update():
	var dir = get_parent().direction
	if dir == Direction.UP:
		rotation_deg = -90
	elif dir == Direction.DOWN:
		rotation_deg = 90
	elif dir == Direction.LEFT:
		rotation_deg = 180
	elif dir == Direction.RIGHT:
		rotation_deg = 0

func _ready():
	if Engine.is_editor_hint():
		set_process(true)

func _process(delta):
	_update()