extends Control

onready var start_btn = get_node("start_game_btn")
onready var how_btn = get_node("how_game_btn")
onready var cred_btn = get_node("cred_game_btn")
onready var quit_btn = get_node("quit_game_btn")

func _ready():
	start_btn.connect("pressed", self, "_on_start_press")
	how_btn.connect("pressed", self, "_on_how_press")
	cred_btn.connect("pressed", self, "_on_cred_press")
	quit_btn.connect("pressed", self, "_on_quit_press")
	
func _on_start_press():
	SceneSwitcher.goto_scene("res://level_select.tscn")

func _on_how_press():
	SceneSwitcher.goto_scene("res://levels/how_to_play.tscn")

func _on_cred_press():
	SceneSwitcher.goto_scene("res://credits.tscn")

func _on_quit_press():
	get_tree().quit()