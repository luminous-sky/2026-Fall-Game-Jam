extends Control

@export var default_button: Button

var buttons: Array


func _ready() -> void:
	# Set default focus
	if default_button:
		default_button.grab_focus()
	
	for element in get_children():
		if element is Button:
			buttons.append(element)
	
	# Turn off music
	Music.play_music_if_not_playing(Music.MUSIC_IDENTIFIER.NONE)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		for button: Button in buttons:
			if not button.has_focus():
				continue
			
			button.pressed.emit()
			continue
