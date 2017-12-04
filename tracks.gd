extends VBoxContainer

var track = load("res://track.tscn")

func _ready():
	pass

func register_taxi(taxi):
	var new_track = track.instance()
	add_child(new_track)
	new_track.set_track_index(taxi.taxi_id)