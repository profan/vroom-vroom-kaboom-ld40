extends Camera2D

var mouse_position = Vector2()

var drag_start = Vector2()
var drag_delta = Vector2()
var dragging = false

const DRAG_SPEED = 1
const MIN_ZOOM = 0.5
const MAX_ZOOM = 3

const ZOOM_MOVE_CLAMP = 24

func _ready():
	pass

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == 3:
			dragging = true
			drag_start.x = event.position.x
			drag_start.y = event.position.y
		elif !event.pressed and event.button_index == 3:
			drag_start.x = 0
			drag_start.y = 0
			dragging = false
		elif event.is_action_pressed("zoom_in"):
			zoom.x = min(zoom.x + 0.1, MAX_ZOOM)
			zoom.y = min(zoom.y + 0.1, MAX_ZOOM)
		elif event.is_action_pressed("zoom_out"):
			zoom.x = max(zoom.x - 0.1, MIN_ZOOM)
			zoom.y = max(zoom.y - 0.1, MIN_ZOOM)
			if abs(zoom.x - MIN_ZOOM) >= 0.00001:
				var gp = get_global_mouse_position()
				var md = gp - global_position
				var clamped_md = md / 6
				global_position.x += clamped_md.x
				global_position.y += clamped_md.y
	elif event is InputEventMouseMotion:
		mouse_position.x = event.position.x
		mouse_position.y = event.position.y

func _process(delta):
	
	if dragging:
		
		var mp = mouse_position
		drag_delta.x = (mp.x - drag_start.x)
		drag_delta.y = (mp.y - drag_start.y)
		
		position.x -= (drag_delta.x) * (zoom.x)
		position.y -= (drag_delta.y) * (zoom.y)
		
		drag_start.x = mp.x
		drag_start.y = mp.y