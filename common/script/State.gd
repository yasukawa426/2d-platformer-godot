@abstract
class_name State extends Node
##  Default base state class each State will extend.
##  States can implement their own version of predefined functions. If they want to main the predefined behavior they must call `super()` inside its implementation followed by their new wanted behavior. 


# ## The animation that should be played on this state
# @export var animation_name: String

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


## Returns the gravity vector computed from all sources affecting the player (so normal gravity + area gravitys, etc)
func _get_gravity() -> Vector2:
	return parent.get_gravity()


func enter() -> void:
	return


func exit() -> void:
	return


## By default, all State apply gravity when not on floor. 
func process_physics(_delta: float) -> State:
	return


func process_frame(_delta: float) -> State:
	return


func process_input(_event: InputEvent) -> State:
	return


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

## fixme: bugged, doesnt reset properly
func squish() -> void:
	var velocity = parent.velocity
	var sprite = parent.sprite
	
	var multiplier =  abs(velocity.y * 0.00005)
	
	
	sprite.scale = Vector2(1 - multiplier, 1 + multiplier ) # flatten it maintaining volume. so, shorter but longer
	#sprite.position.y = multiplier * -100 # move the sprite based on the multiplier so it doesnt start floating
	#sprite.skew = 1 * multiplier
