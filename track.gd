extends HBoxContainer

onready var id_btn = get_node("id_panel/id")
onready var instr_list = get_node("instructions")

var selected_index

func _ready():
	instr_list.connect("item_selected", self, "_on_item_selected")
	id_btn.connect("pressed", self, "_on_id_press")

func set_track_index(i):
	id_btn.text = str(i)

func get_track_id():
	return int(id_btn.text)

func add_instruction(instr):
	instr_list.add_item(instr)

func _on_id_press():
	Game.select_taxi(int(id_btn.text))

func _on_nothing_selected():
	selected_index = -1

func _on_item_selected(i):
	selected_index = i

func _input(event):
	if event.is_action("delete_instruction"):
		if selected_index != -1:
			instr_list.remove_item(selected_index)
			selected_index = -1