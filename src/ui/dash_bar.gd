extends Control


func _ready() -> void:
	$CooldownBar.max_value = Player.dash_cooldown


func _process(_delta: float) -> void:
	if Player.cooldown_time == 0.0:
		if $CooldownBar.visible:
			$CooldownBar.visible = false
		
		return
	
	if not $CooldownBar.visible:
		$CooldownBar.visible = true
	
	$CooldownBar.value = Player.dash_cooldown - Player.cooldown_time
