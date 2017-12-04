extends Node2D

export(int, "UP", "DOWN", "LEFT", "RIGHT") var direction;

onready var body = get_node("body")

enum Direction {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

var taxi_id
var taxi_dir

# vm stuff
var instructions
var pc = 0

func _ready():
	taxi_id = 1
	taxi_dir = direction
	Game.call_deferred("register_taxi", self)

func _process(delta):
	pass