extends Node

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

signal on_taxi_registered(taxi)
signal on_taxi_selected(tid)
signal on_taxi_success(taxi)

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

func _ready():
	set_process(false)
	start_level()

func _process(delta):
	current_time += delta

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
	taxis_done += 1
	taxis[taxi.taxi_id] = null
	dead_taxis[taxi.taxi_id] = taxi
	emit_signal("on_taxi_success", taxi)

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