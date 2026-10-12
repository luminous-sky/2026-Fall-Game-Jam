extends AnimatableBody2D

@export var move_offset: Vector2 = Vector2(300, 0)
@export var time: float = 3.0

func _ready() -> void:
	var start := position
	var tween := create_tween().set_loops()
	tween.tween_property(self, "position", start + move_offset, time)
	tween.tween_property(self, "position", start, time)
