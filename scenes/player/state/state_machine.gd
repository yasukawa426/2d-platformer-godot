class_name StateMachine
extends Node
## Handles the player's state. It pass through function for the player to call and changes states as needed.

## Default starting state for the player (probably idle)
@export var starting_state: State

## Debug label for displaying current state
@onready var state_label: Label = $"../DebugCanvasLayer/GridContainer/StateLabel"
## Debug label for displayng which surface player is touching (wall, floor and ceiling)
@onready var surface_label: Label = $"../DebugCanvasLayer/GridContainer/SurfaceLabel"

## Root node of this Scene (the player)
var _parent: CharacterBody2D

## Current active state.
var current_state: State
var is_debug: bool = false


## Initializes the state machine, passing a player reference to all avaibles states and then enter the default `stating_state`.
func init(parent: Player) -> void:
	for child in get_children(): # give the player node to each state so they can affect the player duh
		child.parent = parent
	
	_parent = parent
	
	is_debug = OS.is_debug_build()
	if is_debug:
		$"../DebugCanvasLayer".show()
	
	change_state(starting_state)# initializes to the default state


## Change to the new starting calling any exit logic and then enter logic for new state.
func change_state(new_state: State) -> void:
	var old_state: State.States 
	if current_state:
		current_state.exit()
		old_state = current_state.get_state_name()
	
	
	current_state = new_state
	current_state.enter(old_state)
	
	if is_debug:
		state_label.text = "State: " + str(current_state).split(":")[0]

## Pass Physics, Frame and Input process for the player, handling state changes if necessary.
func process_input(event: InputEvent) -> void:
	var new_state = current_state.process_input(event)
	
	if is_debug:		
		if _parent:
			var surfaces: PackedStringArray = []
			if _parent.is_on_floor():
				surfaces.append("Floor")
			if _parent.is_on_wall():
				surfaces.append("Wall")
			if _parent.is_on_ceiling():
				surfaces.append("Ceiling")
			
			var final_string = "Surfaces: " + " and ".join(surfaces)
			
			if final_string != surface_label.text:
				surface_label.text = final_string

	if new_state:
		change_state(new_state)


func process_physics(delta: float) -> void:
	var new_state = current_state.process_physics(delta)

	if new_state:
		change_state(new_state)


func process_frame(delta: float) -> void:
	var new_state = current_state.process_frame(delta)

	if new_state:
		change_state(new_state)
