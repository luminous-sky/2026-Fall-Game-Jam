class_name Cutscene
extends Control


@export_file("*.tscn") var next_scene: String

var video_finished: bool = false
var music_finished: bool = false


func _ready() -> void:
	Music.play_music_if_not_playing(Music.MUSIC_IDENTIFIER.CREDITS)
	Music.music_finished.connect(_on_credits_music_finished)


func _on_video_stream_player_finished() -> void:
	video_finished = true
	if music_finished:
		Transition.transition_scene(next_scene, 2.0)


func _on_credits_music_finished() -> void:
	music_finished = true
	if video_finished:
		Transition.transition_scene(next_scene, 2.0)
