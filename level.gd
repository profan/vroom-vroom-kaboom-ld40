extends Node2D

onready var tile_map = get_node("tile_map")
onready var taxis = get_node("taxis")

func _ready():
	
	Game.connect("on_play_level", self, "_on_play_level")
	Game.connect("on_pause_level", self, "_on_pause_level")
	Game.connect("on_stop_level", self, "_on_stop_level")
	
	for taxi in taxis.get_children():
		Game.register_taxi(taxi)
		taxi.set_tilemap(self)

func _on_play_level():
	for taxi in taxis.get_children():
		taxi.on_play()

func _on_pause_level():
	for taxi in taxis.get_children():
		taxi.on_pause()

func _on_stop_level():
	for taxi in taxis.get_children():
		taxi.on_stop()

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == 1:
			var mouse_pos = get_global_mouse_position()
			var tile_pos = world_to_tile_position(mouse_pos / 2)
			var tile_type = tile_at_world_position(mouse_pos / 2)
			print("clicked tile position: ", tile_pos)
			print("clicked tile type: ", tile_type)

func tile_to_world_position(pos):
	return tile_map.map_to_world(pos)

func world_to_tile_position(pos):
	return tile_map.world_to_map(pos)

func tile_at_world_position(pos):
	var tile_pos = tile_map.world_to_map(pos)
	return tile_map.get_cellv(tile_pos)

func test_position_movable(pos):
	var tile = tile_at_world_position(pos)
	if tile != -1 and tile >= 0 and tile <= 12:
		return true
	else:
		return false