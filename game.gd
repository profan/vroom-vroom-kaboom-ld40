extends Node

const Instructions = {
	FORWARD = "^",
	LEFT_TURN = "<",
	RIGHT_TURN = ">",
	U_TURN = "u"
}

signal on_taxi_registered(taxi)

var taxis

func _ready():
	taxis = {}

func start_level():
	taxis = {}

func register_taxi(taxi):
	taxis[taxi.taxi_id] = taxi
	emit_signal("on_taxi_registered", taxi)
	
# called from game code
func get_taxi_count():
	return taxis.size()