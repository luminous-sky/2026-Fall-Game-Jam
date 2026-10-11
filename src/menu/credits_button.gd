extends Button


@onready var credits: ColorRect = $"../Credits"

func _on_pressed() -> void:
	credits.visible = not credits.visible


func _on_mouse_entered() -> void:
	grab_focus()
