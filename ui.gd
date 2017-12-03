extends Control

onready var go_fwd_btn = get_node("instr_container/instr_panels/instr_panel/instructions/go_fwd_btn")
onready var turn_left_btn = get_node("instr_container/instr_panels/instr_panel/instructions/turn_left_btn")
onready var turn_right_btn = get_node("instr_container/instr_panels/instr_panel/instructions/turn_right_btn")
onready var uturn_btn = get_node("instr_container/instr_panels/instr_panel/instructions/uturn_btn")

onready var play_btn = get_node("instr_container/instr_panels/instr_panel/instructions/play_controls/play_btn")
onready var pause_btn = get_node("instr_container/instr_panels/instr_panel/instructions/play_controls/pause_btn")
onready var stop_btn = get_node("instr_container/instr_panels/instr_panel/instructions/play_controls/stop_btn")

onready var tracks = get_node("instr_container/instr_panels/tracks_panel/tracks")
onready var first_track = get_node("instr_container/instr_panels/tracks_panel/tracks_scroll/tracks/track")

func _ready():
	
	go_fwd_btn.connect("pressed", self, "_on_go_fwd")
	turn_left_btn.connect("pressed", self, "_on_turn_left")
	turn_right_btn.connect("pressed", self, "_on_turn_right")
	uturn_btn.connect("pressed", self, "_on_uturn")
	
	play_btn.connect("pressed", self, "_on_play")
	pause_btn.connect("pressed", self, "_on_pause")
	stop_btn.connect("pressed", self, "_on_stop")

func _on_go_fwd():
	first_track.add_instruction("^")

func _on_turn_left():
	first_track.add_instruction("<")

func _on_turn_right():
	first_track.add_instruction(">")
	
func _on_uturn():
	first_track.add_instruction("u")
	
func _on_play():
	pass

func _on_pause():
	pass

func _on_stop():
	pass