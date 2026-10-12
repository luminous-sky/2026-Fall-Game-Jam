extends Area2D


@export_file var next_scene: String


func _ready() -> void:
	$ShardSprite.play("default")


func _on_body_entered(body: Node2D) -> void:
	if body is not Player:
		return
	
	# Pause player, play animation, then transition to new scene
	var player: Player = body
	
	player.can_move = false
	$AnimationPlayer.play("destroy")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "destroy":
		Transition.transition_scene(next_scene, 2.0)
