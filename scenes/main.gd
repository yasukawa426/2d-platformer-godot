extends Node2D
@onready var main: Node2D = $"."
@onready var level: TutorialLevel = $Level
@onready var player: Player = $Player




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level.switch_to_map_camera.connect(player.disable_player_camera)
	level.switch_to_player_camera.connect(player.enable_player_camera)