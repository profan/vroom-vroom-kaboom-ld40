extends HBoxContainer

onready var id_label = get_node("id_panel/id")
onready var instr_list = get_node("instructions")

var selected_index

func _ready():
	instr_list.connect("item_selected", self, "on_item_selected")

func set_track_index(i):
	id_label.text = str(i)

func add_instruction(instr):
	instr_list.add_item(instr)
	
func on_nothing_selected():
	selected_index = -1

func on_item_selected(i):
	selected_index = i

func _input(event):
	if event.is_action("delete_instruction"):
		if selected_index != -1:
			instr_list.remove_item(selected_index)
			selected_index = -1