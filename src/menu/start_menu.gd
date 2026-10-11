extends Control

@export_file("*.tscn") var first_scene: String


# Play animation
func _ready() -> void:
	$AnimationPlayer.play("logo")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "logo" and first_scene:
		get_tree().change_scene_to_file(first_scene)
