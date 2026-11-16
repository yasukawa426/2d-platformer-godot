extends State

@export var move_state: State
@export var jump_state: State
@export var fall_state: State

## Transitions to move and jump states based on player input.
func process_input(event: InputEvent) -> State:
	if event.is_action_pressed("jump") and parent.is_on_floor():
		return jump_state
	
	if event.is_action_pressed("move_left") or event.is_action_pressed("move_right"):
		return move_state
	
	return


## Applies gravity. If the player is not on the floor (while still in the idle_state) goes to fall_state 
func process_physics(delta: float) -> State:
	parent.velocity += _get_gravity() * delta
	parent.move_and_slide()
	
	if not parent.is_on_floor():
		return fall_state
	
	return 
