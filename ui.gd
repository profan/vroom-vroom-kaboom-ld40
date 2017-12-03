extends Control

# add instructions
onready var go_fwd_btn = get_node("instr_container/instr_panels/instr_panel/instructions/go_fwd_btn")
onready var turn_left_btn = get_node("instr_container/instr_panels/instr_panel/instructions/turn_left_btn")
onready var turn_right_btn = get_node("instr_container/instr_panels/instr_panel/instructions/turn_right_btn")
onready var uturn_btn = get_node("instr_container/instr_panels/instr_panel/instructions/uturn_btn")

# control game flow
onready var play_btn = get_node("instr_container/instr_panels/instr_panel/instructions/play_controls/play_btn")
onready var pause_btn = get_node("instr_container/instr_panels/instr_panel/instructions/play_controls/pause_btn")
onready var stop_btn = get_node("instr_container/instr_panels/instr_panel/instructions/play_controls/stop_btn")

# labels to update
onready var time_label = get_node("top_container/time_container/time_value")
onready var taxis_label = get_node("top_container/time_container/taxis_value")

# tracks of instructions
onready var tracks = get_node("instr_container/instr_panels/tracks_panel/tracks_scroll/tracks")
onready var first_track = get_node("instr_container/instr_panels/tracks_panel/tracks_scroll/tracks/track")

func _ready():
	
	go_fwd_btn.connect("pressed", self, "_on_go_fwd")
	turn_left_btn.connect("pressed", self, "_on_turn_left")
	turn_right_btn.connect("pressed", self, "_on_turn_right")
	uturn_btn.connect("pressed", self, "_on_uturn")
	
	play_btn.connect("pressed", self, "_on_play")
	pause_btn.connect("pressed", self, "_on_pause")
	stop_btn.connect("pressed", self, "_on_stop")
	
	Game.connect("on_taxi_registered", self, "_on_taxi_registered")

func _on_taxi_registered(taxi):
	taxis_label.text = str(Game.get_taxi_count())

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