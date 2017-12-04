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
signal on_play_level
signal on_pause_level
signal on_stop_level

var taxis
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
	current_time = 0

func register_taxi(taxi):
	taxis[taxi.taxi_id] = taxi
	emit_signal("on_taxi_registered", taxi)

func select_taxi(tid):
	emit_signal("on_taxi_selected", tid)
	
func get_taxi_count():
	return taxis.size()

# control flow
func run_level():
	set_process(true)

func pause_level():
	set_process(false)

func stop_level():
	set_process(false)
	current_time = 0