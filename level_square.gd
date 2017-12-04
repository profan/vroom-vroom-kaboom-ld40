extends PanelContainer

onready var label = get_node("label")

func _ready():
	label.text = get_name()
