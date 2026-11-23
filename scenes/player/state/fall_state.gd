extends PlayerState

@export var move_state: PlayerState
@export var idle_state: PlayerState
@export var jump_state: PlayerState

## The multiplier to apply to the gravity when falling (make it fall faster, for example). 
@export var _fall_gravity_multiplier: float = 2
@export var _coyote_time: float = 0.2

@export var _jump_buffer_time: float = 0.15

var _coyote_timer: float = 0
var _buffer_timer: float = 0


func get_state_name() -> States:
	return States.FALL

## Returns the gravity vector computed from all sources affecting the player (so normal gravity + area gravitys, etc):

func enter(_old_state: States) -> void:
	_buffer_timer = 0
	if _old_state == States.JUMP:
		_coyote_timer = 0
	else:
		_coyote_timer = _coyote_time

## Applies horizontal movement.
## Applies gravity affect by `_fall_gravity_multiplier`.
## Transitions to idle/move state when landing based on velocity.
## Transitions to jump state if there is jump buffer time left
func process_physics(delta: float) -> PlayerState:
	var direction: float = _get_movement_direction_input()
	if _get_jump():
		parent.velocity += _get_gravity() * delta
	else:
		parent.velocity += _get_gravity() * delta * _fall_gravity_multiplier


	apply_horizontal_movement(direction, true, delta)


	parent.move_and_slide()

	# if landed on floor go to idle or move states
	# if there is jump buffer time go to jump state instead
	if parent.is_on_floor():
		if _buffer_timer > 0:
			return jump_state

		elif direction == 0 and parent.velocity.x == 0:
			return idle_state
		else:
			return move_state
			
	return

func process_frame(delta: float) -> PlayerState:
	_coyote_timer -= delta
	_buffer_timer -= delta

	return

## When pressing jump:
## If there is coyote time left - jump. else add buffer jump time
func process_input(event: InputEvent) -> PlayerState:
	if event.is_action_pressed("jump"):
		if parent.is_on_wall_only():
			return jump_state
		
		if _coyote_timer > 0:
			return jump_state
		
		_buffer_timer = _jump_buffer_time
	
	return

## When landing, apply squish effect
func exit() -> void:
	squish(parent.sprite, true)
