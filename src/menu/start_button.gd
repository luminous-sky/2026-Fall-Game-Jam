extends Button

@export_file("*.tscn") var next_scene: String


func _on_pressed() -> void:
	if not next_scene:
		return
	
	get_tree().change_scene_to_file(next_scene)


func _on_mouse_entered() -> void:
	grab_focus()
