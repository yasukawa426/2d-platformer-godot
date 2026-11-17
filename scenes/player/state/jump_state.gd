extends State

@export var fall_state: State
@export var idle_state: State
@export var move_state: State

@export var _minimum_jump_time: float = 0.2 

var _jump_timer: float = 0

func get_state_name() -> States:
	return States.JUMP


## Amount of vertical speed gained when jumping
@export var jump_velocity: float = -1400

## On enter apply jump velocity and squish effect.
func enter(_old_state: States) -> void:
	super(_old_state)
	
	_jump_timer = _minimum_jump_time
	
	parent.velocity.y = jump_velocity
	squish(parent.sprite, false)

## Applies horizontal movement.
## If the player lets go of the jump key, halves the vertical speed, ending the jump earlier.
## Transitions to FallState when vertical velocity is 0 and to idle/move states if somehow manage to land on floor with positive vertical velocity.
func process_physics(delta: float) -> State:
	parent.velocity += _get_gravity() * delta
	var direction: float = Input.get_axis("move_left", "move_right")
	apply_horizontal_movement(direction, delta)
	
	
	if not Input.is_action_pressed("jump") and _jump_timer <= 0:
		parent.velocity.y *= 0.5

	parent.move_and_slide()
	# if we are no longer going up, change to fall state
	if parent.velocity.y >= 0:
		return fall_state


	# if landed on floor go to idle or move states
	if parent.is_on_floor():
		if direction == 0:
			return idle_state
		else:
			return move_state
			
	return

func process_frame(delta: float) -> State:
	_jump_timer -= delta
	
	return
