extends Control


func _ready() -> void:
	$CooldownBar.max_value = Player.dash_cooldown


func _process(_delta: float) -> void:
	$CooldownBar.value = Player.dash_cooldown - Player.cooldown_time
