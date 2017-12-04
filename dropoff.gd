extends Node2D

onready var label = get_node("label")

func _ready():
	label.text = get_name()

func type():
	return "Dropoff"

func dropoff_id():
	return int(get_name())