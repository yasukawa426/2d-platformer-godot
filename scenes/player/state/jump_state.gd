extends PlayerState

@export var fall_state: PlayerState
@export var idle_state: PlayerState
@export var move_state: PlayerState

## The modifier for jump strength when doing a big jump
@export var _big_jump_modifier: float = 1.2
## Modifier for the movement when doing a side flip. Applied to the rotated `jump_velocity` vector.
@export var _side_flip_modifier: Vector2 = Vector2(1.2, 1.4)
## Modifier for a wall jump. Applied to the rotated `jump_velocity` vector.
@export var _wall_jump_modifier: Vector2 = Vector2(-1.2, 1.5)

## Minimum amount of time that the player gains vertical speed while not holding jump 
@export var _minimum_jump_time: float = 0.2
## Minimum speed required to still be able to do a side flip.
@export var _minimum_side_flip_speed: float = 0.8 * MAX_SPEED

## Amount of vertical speed gained when jumping
@export var jump_velocity: float = -1400

var _jump_timer: float = 0
var _jump_type: JumpTypes

@onready var _flip_tween: Tween


func get_state_name() -> States:
	return States.JUMP


## All available jump types
enum JumpTypes {
	NORMAL, ## Simple jump. Performed when on the ground.
	BIG, ## Bigger normal jump. Performed when transitioning directly from Fallstate but no on wall. So used jump buffer or coyote time.
	WALL, ## Wall jump. Performed when in the air while touching a wall.
	SIDE_FLIP, ## Fas side flip jump. Performed when on the ground when actively decelerating.
}

## On enter apply jump velocity and squish effect.
func enter(old_state: States) -> void:
	super(old_state)
	var direction = _get_movement_direction_input()
	_jump_timer = _minimum_jump_time

	_jump_type = _get_jump_type(old_state)
	
	match _jump_type:
		JumpTypes.NORMAL:
			parent.velocity.y = jump_velocity
		JumpTypes.BIG:
			parent.velocity.y = jump_velocity * _big_jump_modifier
		JumpTypes.WALL:
			var vector = Vector2(0, jump_velocity)
			parent.velocity = vector.rotated(deg_to_rad(45 * direction)) * _wall_jump_modifier
			
		JumpTypes.SIDE_FLIP:
			var vector = Vector2(0, jump_velocity)
			parent.velocity = vector.rotated(deg_to_rad(45 * direction)) * _side_flip_modifier
			_flip(direction)
			#.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		_:
			parent.velocity.y = jump_velocity


	print(JumpTypes.keys()[_jump_type])
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

func _flip(direction: float) -> void:
	## FIXME: make it slower?
	var sprite: Node2D = parent.sprite
	if _flip_tween and _flip_tween.is_running():
		_flip_tween.kill()
		parent.sprite.rotation = 0
		
	_flip_tween = create_tween()
	_flip_tween.tween_property(sprite, "rotation", sprite.rotation + TAU * direction, 0.55)
