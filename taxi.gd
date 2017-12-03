extends Sprite

var taxi_id
var instruction_id
var instructions

func _ready():
	Game.call_deferred("register_taxi", self)

func _process(delta):
	pass