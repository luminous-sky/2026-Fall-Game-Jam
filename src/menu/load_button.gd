extends Button


func _ready() -> void:
	if GameData.data_loaded:
		$Disabled.visible = false
		disabled = false


func _on_pressed() -> void:
	# Change to the correct level
	if not disabled:
		var next_level = GameData.current_level
		Transition.transition_scene(next_level)


func _on_mouse_entered() -> void:
	grab_focus()
