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
signal on_taxi_success(tid)

signal on_play_level
signal on_pause_level
signal on_stop_level

signal on_toggle_labels(v)

var taxis
var taxis_done
var taxis_dead
var current_time

var current_state

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

func register_taxi(taxi):
	taxis[taxi.taxi_id] = taxi
	emit_signal("on_taxi_registered", taxi)

func taxi_reached_destination(taxi):
	taxis_done += 1
	taxis[taxi.taxi_id] = null
	emit_signal("on_taxi_success", taxi.taxi_id)

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

# control flow
func run_level():
	emit_signal("on_play_level")
	set_process(true)

func pause_level():
	emit_signal("on_pause_level")
	set_process(false)

func stop_level():
	emit_signal("on_stop_level")
	set_process(false)
	current_time = 0