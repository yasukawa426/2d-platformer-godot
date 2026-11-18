class_name TutorialLevel
extends Node2D
signal switch_to_map_camera
signal switch_to_player_camera

# TODO: add camera smoothing with the camera plugin
func _on_first_area_2d_body_entered(body: Node2D) -> void:
	var first_camera_2d: Camera2D = $"FirstCamera2D"
	first_camera_2d.enabled = true
	switch_to_map_camera.emit()


func _on_first_area_2d_body_exited(body: Node2D) -> void:
	var first_camera_2d: Camera2D = $"FirstCamera2D"
	first_camera_2d.enabled = false
	switch_to_player_camera.emit()
