extends HBoxContainer

onready var id_btn = get_node("id_panel/id")
onready var instr_list = get_node("instructions_panel/instructions")
onready var instr_pointer = get_node("instructions_panel/instr_pointer")

var selected_index
var instructions

signal on_instructions_changed(new_instr)

func _ready():
	instr_list.connect("gui_input", self, "_on_edit_instructions")
	id_btn.connect("pressed", self, "_on_id_press")
	emit_signal("on_instructions_changed", get_instructions())
	
	Game.connect("on_play_level", self, "_on_play_level")
	Game.connect("on_pause_level", self, "_on_pause_level")
	Game.connect("on_stop_level", self, "_on_stop_level")

func set_track_index(i):
	id_btn.text = str(i)

func get_track_id():
	return int(id_btn.text)

func get_instructions():
	return instr_list.get_text()

func _on_instruction_ptr_moved(new_offset):
	instr_pointer.rect_position.x = (new_offset * instr_pointer.rect_size.x) + 7

func _on_edit_instructions(ev):
	emit_signal("on_instructions_changed", get_instructions())

func _on_play_level():
	instr_pointer.visible = true
	instr_pointer.color.r = 0
	instr_list.editable = false

func _on_pause_level():
	instr_pointer.color.r = 255
	instr_list.editable = false

func _on_stop_level():
	instr_pointer.visible = false
	instr_pointer.rect_position.x = 7 # what the fuc
	instr_list.editable = true

func _on_id_press():
	Game.select_taxi(int(id_btn.text))