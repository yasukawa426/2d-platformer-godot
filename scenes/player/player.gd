extends CharacterBody2D

## Amount of vertical speed gained when jumping
const JUMP_VELOCITY: float = -1000
## Players max horizontal speed
const MAX_SPEED: float = 2000 # pixels/s
## Amount of horizontal speed gained while holding a movement key (left or right). "* 1" means one second for full speed. "* 2" means half a second. / "2 means" 2 seconds.
const ACCELERATION: float = MAX_SPEED * 1 # pixels/s²
## Deceleration when going in the opposite direction of the current movement.
const DECELERATION: float = ACCELERATION * 3
## Deceleration amount when the player isn't pressening anything. Friction I guess 
const IDLE_DCELERATION: float = ACCELERATION / 2


@onready var sprite: MeshInstance2D = $Sprite

#TODO: mario side jump ---> <-- Jump.

const SPEED: float = 300.0
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction: float = Input.get_axis("move_left", "move_right")
	if direction:
		#it means we are trying to go in the oposite direction
		if direction != signf(velocity.x):
			velocity.x += direction * DECELERATION * delta # so the (des)acceleration is twice as strong
		else:
			velocity.x += direction * ACCELERATION * delta 
	else:
		velocity.x = move_toward(velocity.x, 0, IDLE_DCELERATION * delta)  
	

	velocity.x = clamp(velocity.x, MAX_SPEED * -1, MAX_SPEED)
	
	flatten()
	move_and_slide()

func flatten() -> void: 
	var multiplier =  abs(velocity.x * 0.00005)
	
	sprite.scale = Vector2(1 + multiplier, 1 - multiplier ) # flatten it maintaining volume. so, shorter but longer
	sprite.position.y = multiplier * 100 # move the sprite based on the multiplier so it doesnt start floating
	#sprite.skew = 1 * multiplier
