class_name Orb
extends Area2D


## How long it takes the arrow to complete one revolution
const ARROW_SPEED: float = 2.0
const ARROW_DEG_SPEED: float = 360.0 / ARROW_SPEED

# BUG: Dashing after using an orb allows you to launch very high
const LAUNCH_SPEED: float = 300.0
const LAUNCH_TIME: float = 1.5
## The amount to reduce the speed by every second until it is 0
const LAUNCH_RESISTANCE: float = LAUNCH_SPEED / LAUNCH_TIME

var player_interacting: bool = false
var player_node: Player = null

# Current direction of the arrow pointer
var starting_arrow_direction: float = 135.0
var arrow_direction: float = starting_arrow_direction


# Rotate the arrow
func _physics_process(delta: float) -> void:
	if not player_interacting:
		return
	
	# Rotate counter clockwise
	$Arrow.rotation_degrees -= ARROW_DEG_SPEED * delta
	arrow_direction -= ARROW_DEG_SPEED * delta


# Process interaction inputs
func _input(event: InputEvent) -> void:
	if not player_node:
		return
	
	if event.is_action_pressed("interact"):
		# Initialize interaction
		print("pressed")
		player_node.can_move = false
		player_interacting = true
		$Arrow.visible = true
	elif event.is_action_released("interact"):
		# Reset interaction
		print("released")
		
		# TODO: Launch the player gradually, revolving around the orb
		var target_launch = LAUNCH_SPEED * Vector2.from_angle(deg_to_rad(arrow_direction))
		
		# Clamp movement in the x-direction as it seems to be too fast
		if abs(target_launch.x) >= 500.0:
			target_launch.x = sign(target_launch.x) * 500.0
		
		# Increase movement in the y-direction to counter gravity
		if target_launch.y < 0:
			target_launch.y *= 2
		
		player_node.current_launch = target_launch
		
		player_node.can_move = true
		player_interacting = false
		$Arrow.visible = false
		$Arrow.rotation_degrees = 0.0
		arrow_direction = starting_arrow_direction


func _on_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
	
	player_node = body


func _on_body_exited(body: Node2D) -> void:
	if not body is Player:
		return
	
	player_node = body
