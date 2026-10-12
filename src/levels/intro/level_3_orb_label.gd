extends RichTextLabel


const DEFAULT_TEXT = "Hold [color=GOLD]Z[/color] near the orb to [color=GOLD]revolve around it![/color]"
const INTERACT_TEXT = "Release [color=GOLD]Z[/color] to [color=GOLD]launch[/color] in the direction of the arrow!"


func _on_orb_orb_focused() -> void:
	text = INTERACT_TEXT


func _on_orb_orb_unfocused() -> void:
	text = DEFAULT_TEXT
