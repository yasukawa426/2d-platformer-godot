extends State

@export var fall_state: State
@export var idle_state: State
@export var move_state: State

## Amount of vertical speed gained when jumping
@export var jump_velocity: float = -1000


func enter() -> void:
	parent.velocity.y = jump_velocity


func process_physics(delta: float) -> State:
	parent.velocity += _get_gravity() * delta

	# if we are no longer going up, change to fall state
	if parent.velocity.y > 0:
		return fall_state

	var direction: float = Input.get_axis("move_left", "move_right")
	apply_horizontal_movement(direction, delta)
	
	squish()

	parent.move_and_slide()

	# if landed on floor go to idle or move states
	if parent.is_on_floor():
		if direction == 0:
			return idle_state
		else:
			return move_state
			
	return

func exit() -> void:
	squish()
