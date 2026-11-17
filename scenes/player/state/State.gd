@abstract
class_name State extends Node
##  Default base state class each State will extend.
##  States can implement their own version of predefined functions. If they want to main the predefined behavior they must call `super()` inside its implementation followed by their new wanted behavior. 

enum Animations {
	IDLE,
	RUN,
}

## Avaible states
enum States {
	IDLE,
	MOVE,
	JUMP,
	FALL,
}

# ## The animation that should be played on this state
@export var animation: Animations
var _animation_name: String

## Players max horizontal speed
const MAX_SPEED: float = 2000 # pixels/s
## Amount of horizontal speed gained while holding a movement key (left or right). "* 1" means one second for full speed. "* 2" means half a second. / "2 means" 2 seconds.
const ACCELERATION: float = MAX_SPEED * 1 # pixels/s²
## Deceleration when going in the opposite direction of the current movement.
const DECELERATION: float = ACCELERATION * 3
## Deceleration amount when the player isn't pressening anything. Friction I guess 
const IDLE_DECELERATION: float = ACCELERATION / 2

## Reference to the player so that the state can control it.
var parent: Player

@abstract
func get_state_name() -> States
## Should return state

## Returns the gravity vector computed from all sources affecting the player (so normal gravity + area gravitys, etc)
func _get_gravity() -> Vector2:
	return parent.get_gravity()


func enter() -> void:
	match animation:
		Animations.IDLE:
			_animation_name = "idle"
		Animations.RUN:
			_animation_name = "run"
		_:
			_animation_name = "idle"
		
	_change_animation(_animation_name, 0)


func exit() -> void:
	return


## By default, all State apply gravity when not on floor. 
func process_physics(_delta: float) -> State:
	return


func process_frame(_delta: float) -> State:
	return


func process_input(_event: InputEvent) -> State:
	return


## Accelerates the player in the input direction.
## Applies stronger deceleration when reversing direction.
## Gradually slows the player to a stop when no direction is held.
func apply_horizontal_movement(direction: float, delta: float):
	var velocity: Vector2 = parent.velocity

	if direction:
		#it means we are trying to go in the oposite direction
		if direction != signf(velocity.x):
			velocity.x += direction * DECELERATION * delta # so the (des)acceleration is twice as strong
		else:
			velocity.x += direction * ACCELERATION * delta
	else:
		velocity.x = move_toward(velocity.x, 0, IDLE_DECELERATION * delta)

	velocity.x = clamp(velocity.x, MAX_SPEED * -1, MAX_SPEED)
	
	parent.velocity = velocity

## Animates [param sprite_node] with a squash or stretch effect.
## [param landing] determines whether to squash (true) or stretch (false).
## [param duration] controls the duration of each animation phase.
func squish(sprite_node: Node2D, landing: bool, duration: float = 0.1) -> void:
	const VARIATION: float = 0.15

	if parent.squish_tween and parent.squish_tween.is_running():
		parent.squish_tween.kill()


	var initial_scale: Vector2 = parent.initial_sprite_scale
	var new_scale: Vector2 = initial_scale + (Vector2(VARIATION, VARIATION * -1) if landing else Vector2(VARIATION * -1, VARIATION))

	parent.squish_tween = parent.create_tween()
	var tween = parent.squish_tween

	tween.tween_property(
		sprite_node,
		"scale",
		new_scale,
		duration
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	tween.chain().tween_property(
		sprite_node,
		"scale",
		initial_scale,
		duration
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

## Change face to a new animation with a pop effect.
## [param new_animation_name] which animation we should change to.
## [param frame] which frame should be moved to 
func _change_animation(new_animation_name: String, frame: int) -> void:
	var animator: AnimatedSprite2D = parent.face_animator

	if new_animation_name != animator.animation or frame != animator.frame:
		#FIXME: kill any running tween before starting a new one
		var tween: Tween = animator.create_tween()
		var initial_scale: Vector2 = animator.scale
		animator.scale = initial_scale * 1.1
		tween.tween_property(animator, "scale", initial_scale, 0.05)

		animator.animation = new_animation_name
		animator.frame = frame
