extends Control

onready var back_btn = get_node("bottom_buttons/back_button")

var from_scene_name = false

func _ready():
	back_btn.connect("pressed", self, "_on_back_press")

func _on_back_press():
	SceneSwitcher.goto_scene("res://main_menu.tscn")