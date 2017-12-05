extends Node2D

onready var emitter = get_node("emitter")

var lifetime = 0
var is_dead = false
var really_dead = false
var death_time = 1

func _ready():
	set_process(true)

func _process(delta):
	lifetime += delta
	if lifetime >= 0.5 and not is_dead:
		is_dead = true
	elif lifetime >= 0.5 and is_dead and not really_dead:
		death_time -= delta
		modulate.a = 255 / death_time
		if death_time <= 0.75:
			really_dead = true
			queue_free()
