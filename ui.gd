extends Control

# containers
onready var top_container = get_node("top_container")
onready var capture_zoom = get_node("capture_zoom")
onready var instr_container = get_node("instr_container")
onready var win_dialog = get_node("win_dialog")
onready var back_dialog = get_node("back_dialog")

# add instructions
onready var turn_left_btn = get_node("instr_container/instr_panels/instr_panel/instructions/turn_left_btn")
onready var turn_right_btn = get_node("instr_container/instr_panels/instr_panel/instructions/turn_right_btn")

# control game flow
onready var play_btn = get_node("instr_container/instr_panels/instr_panel/instructions/play_controls/play_btn")
onready var pause_btn = get_node("instr_container/instr_panels/instr_panel/instructions/play_controls/pause_btn")
onready var stop_btn = get_node("instr_container/instr_panels/instr_panel/instructions/play_controls/stop_btn")

# labels to update
onready var level_label = get_node("top_container/time_container/level_label")
onready var time_label = get_node("top_container/time_container/time_value")
onready var score_taxis_label = get_node("top_container/time_container/score_taxis_value")
onready var score_alive_label = get_node("top_container/time_container/score_alive_value")

# win labels
onready var win_taxi_rating_label = get_node("win_dialog/win_panel/items/taxi_rating/taxi_rating_value")
onready var win_time_rating_label = get_node("win_dialog/win_panel/items/time_rating/time_rating_value")

# win back button
onready var win_back_button = get_node("win_dialog/win_panel/items/back_btn")

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
	
	play_btn.connect("pressed", self, "_on_play_btn")
	pause_btn.connect("pressed", self, "_on_pause_btn")
	stop_btn.connect("pressed", self, "_on_stop_btn")
	
	show_labels_checkbox.connect("toggled", self, "_on_show_labels_checkbox_toggled")
	
	Game.connect("on_play_level", self, "_on_play")
	Game.connect("on_pause_level", self, "_on_pause")
	Game.connect("on_stop_level", self, "_on_stop")
	Game.connect("on_level_completed", self, "_on_level_completed")
	
	Game.connect("on_taxi_registered", self, "_on_taxi_registered")
	Game.connect("on_taxi_selected", self, "_on_taxi_selected")
	set_process(false)
	
	# set up back dialog
	back_dialog.connect("confirmed", self, "_on_back_dialog_confirmed")
	win_back_button.connect("pressed", self, "_on_win_back_button_pressed")
	
	# initial level name level
	level_label.text = "| %s |" % SceneSwitcher.current_scene.get_name()
	
	# initially off
	pause_btn.disabled = true
	stop_btn.disabled = true
	
	# once on start yes
	call_deferred("_update_labels")
	
func _on_back_dialog_confirmed():
	SceneSwitcher.goto_scene(SceneSwitcher.current_scene.from_scene_name)

func _on_win_back_button_pressed():
	SceneSwitcher.goto_scene(SceneSwitcher.current_scene.from_scene_name)

func _on_level_completed():
	win_dialog.popup()

func _on_show_labels_checkbox_toggled(v):
	Game.toggle_labels(v)

func get_track(id):
	var found_track
	for track in tracks.get_children():
		if track.get_track_id() == id:
			found_track = track
	return found_track

func _input(event):
	if event.is_action("back_to_menu"):
		back_dialog.popup_centered()

func _process(delta):
	_update_labels()

func _update_labels():
	var taxis_done = Game.get_taxi_done_count()
	var taxis_alive = Game.get_taxi_count() - Game.get_taxi_dead_count()
	var taxis_alive_percentage
	if taxis_alive != 0:
		taxis_alive_percentage = (taxis_alive / float(Game.get_taxi_count())) * 100.0
	else:
		taxis_alive_percentage = 0
	time_label.text = "%.2fs" % Game.current_time
	score_taxis_label.text = "%s/%s" % [taxis_done, Game.get_taxi_count()]
	score_alive_label.text = "%.0f %% |" % taxis_alive_percentage

func _on_taxi_registered(taxi):
	tracks.register_taxi(taxi)
	_update_labels()

func _on_taxi_selected(tid):
	current_track = get_track(tid)

func _on_turn_left():
	pass

func _on_turn_right():
	pass
	
func _on_play_btn():
	Game.run_level()
	
func _on_pause_btn():
	Game.pause_level()

func _on_stop_btn():
	Game.stop_level()
	
func _on_play():
	set_process(true)
	pause_btn.disabled = false
	play_btn.disabled = true
	stop_btn.disabled = false

func _on_pause():
	set_process(false)
	pause_btn.disabled = true
	play_btn.disabled = false
	_update_labels()

func _on_stop():
	play_btn.disabled = false
	stop_btn.disabled = true
	pause_btn.disabled = true
	time_label.text = "0.00s"
	_update_labels()
	set_process(false)