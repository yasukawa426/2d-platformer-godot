extends PlayerState

@export var fall_state: PlayerState
@export var idle_state: PlayerState
@export var move_state: PlayerState

## The modifier for jump strength when doing a big jump
@export var _big_jump_modifier: float = 1.2
## Minimum amount of time that the player gains vertical speed while not holding jump 
@export var _minimum_jump_time: float = 0.2

var _jump_timer: float = 0
var _jump_type: JumpTypes

func get_state_name() -> States:
	return States.JUMP


## Amount of vertical speed gained when jumping
@export var jump_velocity: float = -1400


## All available jump types
enum JumpTypes {
	NORMAL, ## Simple jump. Performed when on the ground.
	BIG, ## Bigger normal jump. Performed when transitioning directly from Fallstate but no on wall. So used jump buffer or coyote time.
	WALL, ## Wall jump. Performed when in the air while touching a wall.
	SIDE_FLIP, ## Fas side flip jump. Performed when on the ground when actively decelerating.
}

## On enter apply jump velocity and squish effect.
func enter(_old_state: States) -> void:
	super(_old_state)
	
	_jump_timer = _minimum_jump_time
	_jump_type = _get_jump_type(old_state)
	squish(parent.sprite, false)

## Applies horizontal movement.
## If the player lets go of the jump key, halves the vertical speed, ending the jump earlier.
## Transitions to FallState when vertical velocity is 0 and to idle/move states if somehow manage to land on floor with positive vertical velocity.
func process_physics(delta: float) -> PlayerState:
	parent.velocity += _get_gravity() * delta
	var direction: float = _get_movement_direction_input()
	apply_horizontal_movement(direction, true, delta)
	
	
	if not _get_jump() and _jump_timer <= 0:
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

func process_frame(delta: float) -> PlayerState:
	_jump_timer -= delta
	
	return

func _get_jump_type(old_state: States) -> JumpTypes:
	if parent.is_on_wall_only():
		return JumpTypes.WALL
	elif _is_decelerating() and abs(parent.velocity.x) >= _minimum_side_flip_speed:
		return JumpTypes.SIDE_FLIP
	elif old_state == States.FALL:
		return JumpTypes.BIG
	else:
		return JumpTypes.NORMAL
