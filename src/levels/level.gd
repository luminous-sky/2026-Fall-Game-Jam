class_name Level
extends Node2D


@export var left_bound: int = -999999
@export var right_bound: int = 999999
@export var upper_bound: int = -999999
@export var lower_bound: int = 999999

## Overrides the camera's zoom.
## If the override is set to 0.0, the camera zoom is reset.
@export var zoom_override: float

@export var current_area: GameData.AREAS


# On level load, save the current level and area
func _ready() -> void:
	var current_level: String = get_tree().current_scene.scene_file_path
	
	GameData.current_area = current_area
	GameData.current_level = current_level
	GameData.save_data()
