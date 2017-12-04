extends Control

# containers
onready var top_container = get_node("top_container")
onready var capture_zoom = get_node("capture_zoom")
onready var instr_container = get_node("instr_container")

# add instructions
onready var turn_left_btn = get_node("instr_container/instr_panels/instr_panel/instructions/turn_left_btn")
onready var turn_right_btn = get_node("instr_container/instr_panels/instr_panel/instructions/turn_right_btn")

# control game flow
onready var play_btn = get_node("instr_container/instr_panels/instr_panel/instructions/play_controls/play_btn")
onready var pause_btn = get_node("instr_container/instr_panels/instr_panel/instructions/play_controls/pause_btn")
onready var stop_btn = get_node("instr_container/instr_panels/instr_panel/instructions/play_controls/stop_btn")

# labels to update
onready var time_label = get_node("top_container/time_container/time_value")
onready var score_taxis_label = get_node("top_container/time_container/score_taxis_value")
onready var score_alive_label = get_node("top_container/time_container/score_alive_value")

# ui stuff
onready var show_labels_checkbox = get_node("top_container/time_container/show_labels_checkbox")

# tracks of instructions
onready var tracks = get_node("instr_container/instr_panels/tracks_panel/tracks_scroll/tracks")

# intermediate state
var current_track

func _enter_capture():
	Game.set_ui_focus(false)

func _exit_capture():
	Game.set_ui_focus(true)

func _ready():
	
	capture_zoom.connect("mouse_entered", self, "_enter_capture")
	capture_zoom.connect("mouse_exited", self, "_exit_capture")
	
	turn_left_btn.connect("pressed", self, "_on_turn_left")
	turn_right_btn.connect("pressed", self, "_on_turn_right")
	
	play_btn.connect("pressed", self, "_on_play")
	pause_btn.connect("pressed", self, "_on_pause")
	stop_btn.connect("pressed", self, "_on_stop")
	
	show_labels_checkbox.connect("toggled", self, "_on_show_labels_checkbox_toggled")
	
	Game.connect("on_taxi_registered", self, "_on_taxi_registered")
	Game.connect("on_taxi_selected", self, "_on_taxi_selected")
	set_process(false)
	
	# initially off
	pause_btn.disabled = true
	stop_btn.disabled = true

func _on_show_labels_checkbox_toggled(v):
	Game.toggle_labels(v)

func get_track(id):
	var found_track
	for track in tracks.get_children():
		if track.get_track_id() == id:
			found_track = track
	return found_track

func _process(delta):
	_update_labels()

func _update_labels():
	var taxis_done = Game.get_taxi_done_count()
	var taxis_alive_percentage = (Game.get_taxi_count() / Game.get_taxi_count()) * 100
	time_label.text = "%.2fs" % Game.current_time
	score_taxis_label.text = "%s/%s" % [taxis_done, Game.get_taxi_count()]
	score_alive_label.text = "%s %% |" % taxis_alive_percentage

func _on_taxi_registered(taxi):
	tracks.register_taxi(taxi)
	_update_labels()

func _on_taxi_selected(tid):
	current_track = get_track(tid)

func _on_turn_left():
	pass

func _on_turn_right():
	pass
	
func _on_play():
	Game.run_level()
	set_process(true)
	pause_btn.disabled = false
	play_btn.disabled = true
	stop_btn.disabled = false

func _on_pause():
	Game.pause_level()
	set_process(false)
	pause_btn.disabled = true
	play_btn.disabled = false

func _on_stop():
	play_btn.disabled = false
	stop_btn.disabled = true
	pause_btn.disabled = true
	time_label.text = "0.00s"
	Game.stop_level()
	_update_labels()
	set_process(false)