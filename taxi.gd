extends Sprite

onready var body = get_node("body")

enum Directions {
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
	Game.call_deferred("register_taxi", self)

func _process(delta):
	pass