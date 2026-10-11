extends Area2D

@export_file("*.tscn") var next_scene: String


func _on_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
	
	# Transition to next level
	if next_scene:
		get_tree().call_deferred("change_scene_to_file", next_scene)
