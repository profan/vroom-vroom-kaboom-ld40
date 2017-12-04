extends KinematicBody2D

export(int, "UP", "DOWN", "LEFT", "RIGHT") var direction;

var MOVEMENT_SPEED = 128 # pixels per second i guess, half a tile?
var MOVEMENT_TEST = 40

enum Direction {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

var taxi_id
var taxi_dir
var taxi_pos

# vm stuff
var instructions
var pc = 0

# refs
var tilemap

func _ready():
	taxi_id = 1
	taxi_dir = direction
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
	
	var actual_move = move_delta * MOVEMENT_TEST
	if tilemap.test_position_movable((position + actual_move) / 2):
		position += move_delta * (MOVEMENT_SPEED * delta)