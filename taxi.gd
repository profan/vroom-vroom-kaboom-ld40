extends KinematicBody2D

export(int, "UP", "DOWN", "LEFT", "RIGHT") var direction;

onready var sprite = get_node("sprite")

var MOVEMENT_SPEED = 128 # pixels per second i guess, half a tile?
var MOVEMENT_TEST = 40

enum Direction {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

# initial taxi state
var taxi_id
var taxi_dir
var taxi_pos

# vm stuff
var instructions
var pc = 0

# refs
var tilemap

func _ready():
	taxi_dir = direction
	taxi_id = int(get_name())
	taxi_pos = Vector2(position.x, position.y)
	set_physics_process(false)

func set_tilemap(tm):
	tilemap = tm

func on_play():
	set_physics_process(true)

func on_pause():
	set_physics_process(false)

func on_stop():
	set_physics_process(false)
	position = taxi_pos
	rotation_deg = _get_rotation_angle()

func _get_rotation_angle():
	if taxi_dir == Direction.UP:
		return -90
	elif taxi_dir == Direction.DOWN:
		return 90
	elif taxi_dir == Direction.LEFT:
		return 180
	elif taxi_dir == Direction.RIGHT:
		return 0

func _physics_process(delta):
	
	var move_delta = Vector2()
	
	if taxi_dir == Direction.UP:
		move_delta.x = 0
		move_delta.y = -1
	elif taxi_dir == Direction.DOWN:
		move_delta.x = 0
		move_delta.y = 1
	elif taxi_dir == Direction.LEFT:
		move_delta.x = -1
		move_delta.y = 0
	elif taxi_dir == Direction.RIGHT:
		move_delta.x = 1
		move_delta.y = 0
	
	sprite.rotation_deg = 0
	rotation_deg = _get_rotation_angle()
	
	var actual_move = move_delta * MOVEMENT_TEST
	if tilemap.test_position_movable((position + actual_move) / 2):
		position += move_delta * (MOVEMENT_SPEED * delta)