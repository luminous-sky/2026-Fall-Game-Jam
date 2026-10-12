extends Button

@export_file("*.tscn") var next_scene: String


func _on_pressed() -> void:
	if not next_scene:
		return
	
	Transition.transition_scene(next_scene)


# TODO: Fix the mouse not selecting the button
func _on_mouse_entered() -> void:
	grab_focus()
