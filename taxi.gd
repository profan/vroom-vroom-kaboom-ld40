extends Area2D

export(int, "UP", "DOWN", "LEFT", "RIGHT") var direction;

onready var sprite = get_node("sprite")
onready var label_panel = get_node("label_panel")
onready var label = get_node("label_panel/label")

var MOVEMENT_SPEED = 128 # pixels per second i guess, half a tile?
var MOVEMENT_TEST = 32

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

# intermediate
var cur_move_delta = Vector2()
var cur_direction
var last_tile_pos
var cur_tile_pos

# vm stuff
var instructions
var pc

# refs
var tilemap

signal on_instruction_pointer_move(new_offset)

func _ready():
	taxi_dir = direction
	taxi_id = int(get_name())
	taxi_pos = Vector2(position.x, position.y)
	cur_direction = taxi_dir
	
	# label yes
	label.text = get_name()
	Game.connect("on_toggle_labels", self, "_on_toggle_labels")
	
	# collision stuff
	connect("area_entered", self, "_on_area_enter")
	connect("area_exited", self, "_on_area_exit")
	
	# resetto
	on_stop()

func _label_input(ev):
	if ev is InputEventMouseButton:
		if ev.pressed and ev.button_index == 1:
			Game.scroll_to_taxi_id(taxi_id)
			print("PEW!")
	
func type():
	return "Taxi"

func _on_area_enter(a):
	if a.type() == "Taxi": # BANG
		Game.taxi_got_exploded(self)
		Game.taxi_got_exploded(a)
	elif a.type() == "Dropoff":
		if str(a.dropoff_id()) == get_name():
			Game.taxi_reached_destination(self)
	
func _on_area_exit(a):
	pass

func _on_toggle_labels(v):
	label_panel.visible = v

func _on_label_press():
	Game.scroll_to_taxi_id(taxi_id)

func set_tilemap(tm):
	tilemap = tm
	last_tile_pos = tilemap.world_to_tile_position(position / 2)
	cur_tile_pos = last_tile_pos

func _on_new_instructions(instr):
	if not is_physics_processing():
		instructions = instr
		pc = 0

func on_play():
	set_physics_process(true)

func on_pause():
	set_physics_process(false)

func on_stop():
	cur_direction = taxi_dir
	cur_move_delta = _direction_to_delta(cur_direction)
	set_physics_process(false)
	sprite.rotation_deg = _get_rotation_angle()
	position = taxi_pos
	pc = 0

func _get_rotation_angle():
	if cur_direction == Direction.UP:
		return -90
	elif cur_direction == Direction.DOWN:
		return 90
	elif cur_direction == Direction.LEFT:
		return 180
	elif cur_direction == Direction.RIGHT:
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

func _are_we_intersection():
	var left_tpos = cur_tile_pos + _direction_to_delta(_direction_turn(cur_direction, Turn.LEFT))
	var right_tpos = cur_tile_pos + _direction_to_delta(_direction_turn(cur_direction, Turn.RIGHT))
	if tilemap.test_tile_position_movable(left_tpos) or tilemap.test_tile_position_movable(right_tpos):
		return true
	else:
		return false

func _interpret():
	
	var new_move = Vector2()
	var current_move = _direction_to_delta(cur_direction)
	
	if instructions == null: return current_move
	if instructions.length() != 0 and pc < instructions.length():
		var cur_instr = instructions[pc]
		if cur_instr == "^": # continue straight
			if _are_we_intersection():
				pc += 1
				emit_signal("on_instruction_pointer_move", pc)
			new_move.x = current_move.x
			new_move.y = current_move.y
		elif cur_instr == "<":
			var new_dir = _direction_turn(cur_direction, Turn.LEFT)
			var move_delta = _direction_to_delta(new_dir)
			var left_move = move_delta
			if tilemap.test_tile_position_movable(cur_tile_pos + left_move):
				new_move.x = move_delta.x
				new_move.y = move_delta.y
				cur_direction = new_dir
				pc += 1
				emit_signal("on_instruction_pointer_move", pc)
			else:
				new_move.x = current_move.x
				new_move.y = current_move.y
		elif cur_instr == ">":
			var new_dir = _direction_turn(cur_direction, Turn.RIGHT)
			var move_delta = _direction_to_delta(new_dir)
			var right_move = move_delta
			if tilemap.test_tile_position_movable(cur_tile_pos + right_move):
				new_move.x = move_delta.x
				new_move.y = move_delta.y
				cur_direction = new_dir
				pc += 1
				emit_signal("on_instruction_pointer_move", pc)
			else:
				new_move.x = current_move.x
				new_move.y = current_move.y
		elif cur_instr == "u":
			var new_dir = _direction_turn(cur_direction, Turn.UTURN)
			var move_delta = _direction_to_delta(new_dir)
			var uturn_move = move_delta
			if tilemap.test_position_movable(cur_tile_pos + uturn_move):
				new_move.x = move_delta.x
				new_move.y = move_delta.y
				cur_direction = new_dir
				pc += 1
				emit_signal("on_instruction_pointer_move", pc)
			else:
				new_move.x = current_move.x
				new_move.y = current_move.y
		else:
			return current_move
	
	return new_move

func _physics_process(delta):
	
	sprite.rotation_deg = _get_rotation_angle()
	cur_tile_pos = tilemap.world_to_tile_position(position / 2)
	
	var ctp_w = tilemap.tile_to_world_position(cur_tile_pos)
	if cur_direction == Direction.UP:
		ctp_w.x += 16
	elif cur_direction == Direction.LEFT:
		ctp_w.y += 16
	else:
		ctp_w.x += 16
		ctp_w.y += 16
	
	# now get instruction and move yes, else keep using last delta
	if cur_tile_pos.x != last_tile_pos.x or cur_tile_pos.y != last_tile_pos.y:
		
		var mid_dist = ctp_w.distance_to((position - Vector2(16, 16)) / 2)
		
		if mid_dist < 12:
			cur_move_delta = _interpret()
			last_tile_pos.x = cur_tile_pos.x
			last_tile_pos.y = cur_tile_pos.y
			
			var actual_move = cur_move_delta * MOVEMENT_TEST
			if tilemap.test_position_movable((position + actual_move) / 2):
				position += cur_move_delta * (MOVEMENT_SPEED * delta)
			
			# restore
			cur_move_delta = _direction_to_delta(cur_direction)
			return
	
	var actual_move = cur_move_delta * MOVEMENT_TEST
	if tilemap.test_position_movable((position + actual_move) / 2):
		position += cur_move_delta * (MOVEMENT_SPEED * delta)