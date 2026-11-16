extends State

@export var move_state: State
@export var idle_state: State

func process_physics(delta: float) -> State:
	parent.velocity += _get_gravity() * delta


	var direction: float = Input.get_axis("move_left", "move_right")
	apply_horizontal_movement(direction, delta)

	parent.move_and_slide()

	# if landed on floor go to idle or move states
	if parent.is_on_floor():
		if direction == 0 and parent.velocity.x == 0:
			return idle_state
		else:
			return move_state
			
	return

func exit() -> void:
	squish(parent.sprite, true)
