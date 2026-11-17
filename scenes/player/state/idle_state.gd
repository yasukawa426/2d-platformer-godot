extends State

@export var move_state: State
@export var jump_state: State
@export var fall_state: State

## Idle time in seconds needed for the player to start sleeping 
@export var _sleep_time: float = 10
## The amount the player get flattened when sleeping
@export var _flat_intesity: float = 0.15

## Time since entered idle state
var _idle_time: float
## If the player is sleeping (passed enough idle time for him to start sleeping)
var _sleeping: bool = false

## Resets sleep trackers
func enter(_old_state: States) -> void:
	super(_old_state)

	_idle_time = 0
	_sleeping = false


func get_state_name() -> States:
	return States.IDLE

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

## If _sleep_time has passed plays a sleeping animation
func process_frame(delta: float) -> State:
	_idle_time += delta

	if _idle_time >= _sleep_time and not _sleeping:
		var direction: float
		direction = -1 if parent.face_animator.position == parent.left_marker_2d.position else 1

		_sleeping = true
		_change_animation(parent.face_animator.animation, 1)
		parent.face_animator.rotate(deg_to_rad(20 * direction))

	if _sleeping and not parent.squish_tween.is_running():
		squish(parent.sprite, true, 2)
	return

## Resets player to initial scale and rotation
func exit() -> void:
	if parent.squish_tween and parent.squish_tween.is_running():
		parent.squish_tween.kill()

	parent.squish_tween = parent.create_tween()
	var tween = parent.squish_tween

	tween.tween_property(
		parent.sprite,
		"scale",
		parent.initial_sprite_scale,
		0.1
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	parent.face_animator.rotation = deg_to_rad(0)
