extends Node

func _ready():
	Game.connect("on_taxi_success", self, "_on_taxi_success")
	Game.connect("on_taxi_failure", self, "_on_taxi_failure")

func _on_taxi_success(taxi):
	call_deferred("remove_child", taxi)

func _on_taxi_failure(taxi):
	call_deferred("remove_child", taxi)