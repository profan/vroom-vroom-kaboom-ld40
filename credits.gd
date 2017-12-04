extends Control

onready var back_btn = get_node("bottom_buttons/back_button")

var from_scene_name = false

func _ready():
	back_btn.connect("pressed", self, "_on_back_btn_pressed")
	
func _on_back_btn_pressed():
	SceneSwitcher.goto_scene(from_scene_name)