extends Node2D

signal music_finished

enum MUSIC_IDENTIFIER {
	NONE,
	INTRO,
	MAIN,
	FINAL,
	CREDITS,
}

var currently_playing: MUSIC_IDENTIFIER

@onready var identifier_to_node: Dictionary[MUSIC_IDENTIFIER, AudioStreamPlayer] = {
	MUSIC_IDENTIFIER.INTRO: $Intro,
	MUSIC_IDENTIFIER.MAIN: $Main,
	MUSIC_IDENTIFIER.FINAL: $Final,
	MUSIC_IDENTIFIER.CREDITS: $Credits,
}


## Plays a provided audio file if it is not already playing.
func play_music_if_not_playing(identifier: MUSIC_IDENTIFIER) -> void:
	if identifier == MUSIC_IDENTIFIER.NONE:
		if currently_playing != MUSIC_IDENTIFIER.NONE:
			identifier_to_node[currently_playing].stop()
			identifier_to_node[currently_playing].finished.disconnect(_on_music_finished)
		
		return
	
	if currently_playing == identifier:
		return
	
	if currently_playing != MUSIC_IDENTIFIER.NONE:
		identifier_to_node[currently_playing].stop()
		identifier_to_node[currently_playing].finished.disconnect(_on_music_finished)
	
	currently_playing = identifier
	identifier_to_node[currently_playing].play()
	identifier_to_node[currently_playing].finished.connect(_on_music_finished)


func _on_music_finished() -> void:
	music_finished.emit()
