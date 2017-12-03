extends HBoxContainer

onready var instr_list = get_node("instructions")

var selected_index

func _ready():
	instr_list.connect("item_selected", self, "on_item_selected")
	instr_list.connect("focus_exited", self, "on_nothing_selected")

func add_instruction(instr):
	instr_list.add_item(instr)
	
func on_nothing_selected(i):
	selected_index = -1

func on_item_selected(i):
	selected_index = i

func _input(event):
	if event.is_action("delete_instruction"):
		if selected_index != -1:
			instr_list.remove_item(selected_index)
			selected_index = -1