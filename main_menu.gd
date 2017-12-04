extends Control

onready var start_btn = get_node("start_game_btn")
onready var quit_btn = get_node("quit_game_btn")

func _ready():
	start_btn.connect("pressed", self, "_on_start_press")
	quit_btn.connect("pressed", self, "_on_quit_press")
	
func _on_start_press():
	SceneSwitcher.goto_scene("res://level_select.tscn")

func _on_quit_press():
	get_tree().quit()