class_name Player
extends CharacterBody2D

# ## Amount of vertical speed gained when jumping
# const JUMP_VELOCITY: float = -1000
# ## Players max horizontal speed
# const MAX_SPEED: float = 2000 # pixels/s
# ## Amount of horizontal speed gained while holding a movement key (left or right). "* 1" means one second for full speed. "* 2" means half a second. / "2 means" 2 seconds.
# const ACCELERATION: float = MAX_SPEED * 1 # pixels/s²
# ## Deceleration when going in the opposite direction of the current movement.
# const DECELERATION: float = ACCELERATION * 3
# ## Deceleration amount when the player isn't pressening anything. Friction I guess 
# const IDLE_DECELERATION: float = ACCELERATION / 2

## The player node which contain all other sprite related nodes.
@onready var sprite: Node2D = $Sprite
## The AnimatedSprite2D node responsible for animating the player's face.
@onready var face_animator: AnimatedSprite2D = $Sprite/FaceAnimatedSprite2D
## The StateMachine resposible for managing player state
@onready var state_machine: StateMachine = $StateMachine

## Marker2D for the position the face should be when going left
@onready var left_marker_2d: Marker2D = $Sprite/LeftMarker2D
## Marker2D for the position the face should be when going right
@onready var right_marker_2d: Marker2D = $Sprite/RightMarker2D

## Initial sprites scale
@onready var initial_sprite_scale: Vector2 = sprite.scale
## Initial face sprites scale
@onready var initial_face_scale: Vector2 = face_animator.scale

## Tween responsible for squishing the player when jumping and landing.
var squish_tween: Tween;
## Tween responsible for deforming the face sprites
var face_tween: Tween;

func _ready() -> void:
	state_machine.init(self)


func _process(delta: float) -> void:
	state_machine.process_frame(delta)


func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)


func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)
