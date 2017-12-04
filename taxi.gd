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

enum Turn {
	LEFT,
	RIGHT,
	UTURN	
}

# initial taxi state
var taxi_id
var taxi_dir
var taxi_pos

# vm stuff
var instructions
var pc

# refs
var tilemap

func _ready():
	taxi_dir = direction
	taxi_id = int(get_name())
	taxi_pos = Vector2(position.x, position.y)
	set_physics_process(false)

func set_tilemap(tm):
	tilemap = tm

func _on_new_instructions(instr):
	instructions = instr
	pc = 0

func on_play():
	set_physics_process(true)

func on_pause():
	set_physics_process(false)

func on_stop():
	set_physics_process(false)
	direction = taxi_dir
	rotation_deg = _get_rotation_angle()
	position = taxi_pos
	pc = 0

func _get_rotation_angle():
	if taxi_dir == Direction.UP:
		return -90
	elif taxi_dir == Direction.DOWN:
		return 90
	elif taxi_dir == Direction.LEFT:
		return 180
	elif taxi_dir == Direction.RIGHT:
		return 0

func _direction_to_delta(dir):
	
	var move_delta = Vector2()
	
	if dir == Direction.UP:
		move_delta.x = 0
		move_delta.y = -1
	elif dir == Direction.DOWN:
		move_delta.x = 0
		move_delta.y = 1
	elif dir == Direction.LEFT:
		move_delta.x = -1
		move_delta.y = 0
	elif dir == Direction.RIGHT:
		move_delta.x = 1
		move_delta.y = 0
		
	return move_delta

func _direction_turn(dir, turn):
	if dir == Direction.UP:
		if turn == Turn.LEFT:		return Direction.LEFT
		elif turn == Turn.RIGHT: 	return Direction.RIGHT
		elif turn == Turn.UTURN: 	return Direction.DOWN
			
	elif dir == Direction.DOWN:
		if turn == Turn.LEFT: 		return Direction.RIGHT
		elif turn == Turn.RIGHT: 	return Direction.LEFT
		elif turn == Turn.UTURN: 	return Direction.UP
			
	elif dir == Direction.LEFT:
		if turn == Turn.LEFT: 		return Direction.DOWN
		elif turn == Turn.RIGHT: 	return Direction.UP
		elif turn == Turn.UTURN: 	return Direction.RIGHT
			
	elif dir == Direction.RIGHT:
		if turn == Turn.LEFT: 		return Direction.UP
		elif turn == Turn.RIGHT: 	return Direction.DOWN
		elif turn == Turn.UTURN: 	return Direction.LEFT

func _interpret():
	
	var new_move = Vector2()
	var current_move = _direction_to_delta(taxi_dir)
	
	if instructions == null: return current_move
	if instructions.length() != 0 and pc < instructions.length() - 1:
		var cur_instr = instructions[pc]
		if cur_instr == "<":
			var new_dir = _direction_turn(taxi_dir, Turn.LEFT)
			var move_delta = _direction_to_delta(new_dir)
			var left_move = move_delta * MOVEMENT_TEST
			if tilemap.test_position_movable((position + left_move) / 2):
				new_move.x = left_move.x
				new_move.y = left_move.y
				taxi_dir = new_dir
				pc += 1
			else:
				new_move.x = current_move.x
				new_move.y = current_move.y
		elif cur_instr == ">":
			var new_dir = _direction_turn(taxi_dir, Turn.LEFT)
			var move_delta = _direction_to_delta(new_dir)
			var right_move = move_delta * MOVEMENT_TEST
			if tilemap.test_position_movable((position + right_move) / 2):
				new_move.x = right_move.x
				new_move.y = right_move.y
				taxi_dir = new_dir
				pc += 1
			else:
				new_move.x = current_move.x
				new_move.y = current_move.y
		elif cur_instr == "u":
			var new_dir = _direction_turn(taxi_dir, Turn.UTURN)
			var move_delta = _direction_to_delta(new_dir)
			var uturn_move = move_delta * MOVEMENT_TEST
			if tilemap.test_position_movable((position + uturn_move) / 2):
				new_move.x = uturn_move.x
				new_move.y = uturn_move.y
				taxi_dir = new_dir
				pc += 1
			else:
				new_move.x = current_move.x
				new_move.y = current_move.y
		else:
			return current_move
	
	return new_move

func _physics_process(delta):
	
	sprite.rotation_deg = 0
	rotation_deg = _get_rotation_angle()
	
	# now get instruction and move yes
	var current_move_delta = _interpret()
	
	var actual_move = current_move_delta * MOVEMENT_TEST
	if tilemap.test_position_movable((position + actual_move) / 2):
		position += current_move_delta * (MOVEMENT_SPEED * delta)