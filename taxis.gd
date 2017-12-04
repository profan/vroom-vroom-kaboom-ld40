extends Node

func _ready():
	Game.connect("on_taxi_success", self, "_on_taxi_success")

func _on_taxi_success(taxi):
	call_deferred("remove_child", taxi)