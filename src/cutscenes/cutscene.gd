class_name Cutscene
extends Control


@export_file("*.tscn") var next_scene: String


func _on_video_stream_player_finished() -> void:
	Transition.transition_scene(next_scene, 2.0)
