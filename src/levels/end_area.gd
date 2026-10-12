extends Area2D

@export_file("*.tscn") var next_scene: String


func _on_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
	
	var player: Player = body
	
	# Transition to next level
	if next_scene:
		player.can_move = false
		Transition.transition_scene(next_scene)
