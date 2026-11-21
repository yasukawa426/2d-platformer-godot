## Base State class that should be extended for other types of state (for example, PlayerState and EnemyState)
@abstract
class_name BaseState extends Node
##  Default base state class each State will extend.
##  States can implement their own version of predefined functions. If they want to main the predefined behavior they must call `super(_old_state)` inside its implementation followed by their new wanted behavior. 


## Reference to the player so that the state can control it.
var parent: CharacterBody2D


## How the animation change will be handled.
@abstract
func _change_animation(animation_name: String, frame: int)


## This function need to return which way the Body will be moving (for player something like pressing left or right while a enemy may be changing dir when hitting a wall)
@abstract
func _get_movement_direction_input() -> float


## Wether the body should jump
@abstract
func _get_jump() -> bool

## Returns the gravity vector computed from all sources affecting the player (so normal gravity + area gravitys, etc)
func _get_gravity() -> Vector2:
	return parent.get_gravity()


## `_old_state` represent the current state before transitioning into this one.
func enter(_old_state) -> void:
	return
			

func exit() -> void:
	return


## By default, all State apply gravity when not on floor. 
func process_physics(_delta: float) -> BaseState:
	return


func process_frame(_delta: float) -> BaseState:
	return


func process_input(_event: InputEvent) -> BaseState:
	return
