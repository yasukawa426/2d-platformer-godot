class_name Player
extends CharacterBody2D

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

## Player camera
@onready var camera_2d: Camera2D = $Camera2D

## Initial sprites scale
@onready var initial_sprite_scale: Vector2 = sprite.scale
## Initial face sprites scale
@onready var initial_face_scale: Vector2 = face_animator.scale

## Tween responsible for squishing the player when jumping and landing.
var squish_tween: Tween;
## Tween responsible for deforming the face sprites
var face_tween: Tween;

# TODO:
# implement side jump
# implement wall jump

func _ready() -> void:
	state_machine.init(self)


func _process(delta: float) -> void:
	state_machine.process_frame(delta)


func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)


func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)


func enable_player_camera() -> void:
	camera_2d.enabled = true


func disable_player_camera() -> void:
	camera_2d.enabled = false
