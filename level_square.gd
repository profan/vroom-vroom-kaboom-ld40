extends Button

onready var comp_bg = get_node("completed_bg")

func _ready():
	comp_bg.visible = Game.completed_levels.has(get_name())
	text = get_name()

func _pressed():
	SceneSwitcher.goto_scene("res://levels/%s.tscn" % get_name())
