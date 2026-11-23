extends Camera2D
const LOOK_AHEAD_DISTANCE: float = 600
const CAMERA_OFFSET_SPEED: float = 1
const CAMERA_SMOOTHING: float = 3

@onready var player: Player = $".."

var _direction: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var target_offset: float = 0
	
	if abs(player.velocity.x) > 400:
		target_offset = sign(player.velocity.x) * LOOK_AHEAD_DISTANCE

	offset.x = lerp(offset.x, target_offset, 1 -  exp(-CAMERA_OFFSET_SPEED * delta))


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("move_left"):
		_direction = -1
	if event.is_action_pressed("move_right"):
		_direction = 1
