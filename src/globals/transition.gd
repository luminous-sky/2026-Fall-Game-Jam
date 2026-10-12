extends CanvasLayer


## Fades the transition screen into view, then changes the scene
func transition_scene(next_scene: String, time: float = 1.0) -> void:
	var tween := $Background.create_tween()
	tween.tween_property($Background, "modulate", Color(1.0, 1.0, 1.0, 1.0), time)
	tween.tween_callback(_finish_transition.bind(next_scene, time))


# Finishes the transition screen
func _finish_transition(next_scene: String, time: float = 1.0):
	get_tree().call_deferred("change_scene_to_file", next_scene)
	
	var tween := $Background.create_tween()
	tween.tween_property($Background, "modulate", Color(1.0, 1.0, 1.0, 0.0), time)
