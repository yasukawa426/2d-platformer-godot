extends State

@export var idle_state: State
@export var jump_state: State
@export var fall_state: State

#TODO: side jump ---> <-- Jump.


func get_state_name() -> States:
	return States.MOVE

## List for the player input and applies horizontal movement.
## Changes face animation based on speed.
## Changes face position based on movement direction
## Transitions to FallState if not on floor and to IdleState if there is no movement
func process_physics(delta: float) -> State:
	var direction: float = Input.get_axis("move_left", "move_right")
	apply_horizontal_movement(direction, false, delta)
	
	if abs(parent.velocity.x) >= MAX_SPEED * 0.9:
		_change_animation(_animation_name, 1)
	else:
		_change_animation(_animation_name, 0)
	
	if direction < 0:
		parent.face_animator.position = parent.left_marker_2d.position
	elif direction > 0:
		parent.face_animator.position = parent.right_marker_2d.position

	if not parent.is_on_floor():
		return fall_state
	
	if parent.velocity == Vector2.ZERO and direction == 0:
		return idle_state

	parent.move_and_slide()
	flatten()
	return

## Transitions to jump state.
func process_input(event: InputEvent) -> State:
	if event.is_action_pressed("jump") and parent.is_on_floor():
		return jump_state
	return

## Animates the player sprite with a squatch effect
func flatten() -> void:
	var stretch: float = abs(parent.velocity.x * 0.00005)
	var squash: float = 1.0 - stretch
	var sprite = parent.sprite

	sprite.scale = Vector2(1.0 + stretch, squash)
