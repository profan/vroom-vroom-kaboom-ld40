extends Node

var explosion = load("res://explosion.tscn")

const Instructions = {
	LEFT_TURN = "<",
	RIGHT_TURN = ">",
	U_TURN = "u"
}

enum State {
	RUNNING,
	PAUSED,
	STOPPED
}

# historic state, to be saved maybe?
var completed_levels

# signal stuff
signal on_taxi_registered(taxi)
signal on_taxi_selected(tid)
signal on_taxi_success(taxi)
signal on_taxi_failure(taxi)
signal on_level_completed

signal on_play_level
signal on_pause_level
signal on_stop_level

signal on_toggle_labels(v)

var taxis
var taxis_done
var taxis_dead
var current_time

# keep old ones here
var dead_taxis

var current_state
var ui_has_focus

# platform-related issue fix
func _unbodge_input():
		
	var new_event
	var actions = InputMap.get_action_list("do_drag")
	for event in actions:
		if OS.get_name() == "HTML5" and event.button_index == 2:
			new_event = event
		elif event.button_index == 3:
			new_event = event
	
	InputMap.erase_action("do_drag")
	InputMap.add_action("do_drag")
	InputMap.action_add_event("do_drag", new_event)

func _ready():
	_unbodge_input()
	completed_levels = {}
	set_process(false)

func _process(delta):
	current_time += delta
	
# save/load
func load_game():
	pass

func save_game():
	pass

# called from game code
func start_level():
	taxis = {}
	taxis_done = 0
	taxis_dead = 0
	current_time = 0
	dead_taxis = {}
	ui_has_focus = false

func register_taxi(taxi):
	taxis[taxi.taxi_id] = taxi
	emit_signal("on_taxi_registered", taxi)

func taxi_reached_destination(taxi):
	if not dead_taxis.has(taxi.taxi_id):
		taxis_done += 1
		taxis[taxi.taxi_id] = null
		dead_taxis[taxi.taxi_id] = taxi
		emit_signal("on_taxi_success", taxi)
	if taxis_done == get_taxi_count():
		var cur_scene_name = SceneSwitcher.current_scene.get_name()
		completed_levels[cur_scene_name] = true
		emit_signal("on_level_completed")

func taxi_got_exploded(taxi):
	if not dead_taxis.has(taxi.taxi_id):
		taxis_dead += 1
		taxis[taxi.taxi_id] = null
		dead_taxis[taxi.taxi_id] = taxi
		emit_signal("on_taxi_success", taxi)
		var taxi_pos = Vector2(taxi.global_position.x, taxi.global_position.y)
		# emit explosion yes
		var cur_scene = SceneSwitcher.current_scene
		var new_explosion = explosion.instance()
		cur_scene.add_child(new_explosion)
		new_explosion.global_position = taxi_pos

func select_taxi(tid):
	emit_signal("on_taxi_selected", tid)
	
func get_taxi_count():
	return taxis.size()

func get_taxi_done_count():
	return taxis_done

func get_taxi_dead_count():
	return taxis_dead

func toggle_labels(v):
	emit_signal("on_toggle_labels", v)

# taxi restoration yes
func restore_taxis(scene):
	for tid in dead_taxis:
		scene.add_child(dead_taxis[tid])
	dead_taxis.clear()

func ui_has_focus():
	return ui_has_focus

func set_ui_focus(v):
	ui_has_focus = v
	
func scroll_to_taxi_id(tid):
	pass

# control flow
func run_level():
	current_state = State.RUNNING
	emit_signal("on_play_level")
	set_process(true)

func pause_level():
	current_state = State.PAUSED
	emit_signal("on_pause_level")
	set_process(false)

func stop_level():
	current_state = State.STOPPED
	emit_signal("on_stop_level")
	set_process(false)
	current_time = 0
	taxis_dead = 0
	taxis_done = 0