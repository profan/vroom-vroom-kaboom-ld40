extends Camera2D

var mouse_position = Vector2()

var drag_start = Vector2()
var drag_delta = Vector2()
var dragging = false

const DRAG_SPEED = 1
const MAX_DRAG_SPEED = 24 # pixels per frame in each direction

const MIN_ZOOM = 0.1
const MAX_ZOOM = 2

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
			zoom.y = min(zoom.x + 0.1, MAX_ZOOM)
		elif event.is_action_pressed("zoom_out"):
			zoom.x = max(zoom.x - 0.1, MIN_ZOOM)
			zoom.y = max(zoom.y - 0.1, MIN_ZOOM)
	elif event is InputEventMouseMotion:
		mouse_position.x = event.position.x
		mouse_position.y = event.position.y

func _process(delta):
	
	if dragging:
		
		var mp = mouse_position
		drag_delta.x = (mp.x - drag_start.x)
		drag_delta.y = (mp.y - drag_start.y)
		# drag_delta.clamped(MAX_DRAG_SPEED)
		
		position.x -= drag_delta.x
		position.y -= drag_delta.y
		
		drag_start.x = mp.x
		drag_start.y = mp.y