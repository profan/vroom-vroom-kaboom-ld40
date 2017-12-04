extends Button

func _ready():
	text = get_name()

func _pressed():
	SceneSwitcher.goto_scene("res://levels/%s.tscn" % get_name())
