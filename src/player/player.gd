class_name Player
extends CharacterBody2D


const SPEED: float = 300.0
const JUMP_VELOCITY: float = -400.0

## How fast the player moves when dashing
const DASH_SPEED: float = 600.0

## How long the dash lasts for, in seconds
const DASH_TIME: float = 0.50
## How much the speed decreases by per second after a dash
const DASH_RESISTANCE: float = (DASH_SPEED - SPEED) / DASH_TIME

## Grace time, in seconds, before the player cannot jump after falling
const FALL_GRACE_TIME: float = 0.15

@export var dash_cooldown: float = 2.0

# Current fall time
var fall_time: float = 0.0
var can_jump: bool = true


# Current dash cooldown time
var cooldown_time: float = 0.0

# Current horizontal movement speed
var current_speed: float = SPEED
var can_dash: bool = true


func _physics_process(delta: float) -> void:
	# Reset dash after the cooldown is over
	if not can_dash:
		cooldown_time += delta
		if cooldown_time >= dash_cooldown:
			can_dash = true
			cooldown_time = 0.0
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
		# Prevent jumping after the coyote time
		fall_time += delta
		if fall_time >= FALL_GRACE_TIME:
			can_jump = false
	else:
		# Reset the jump grace period
		can_jump = true
		fall_time = 0.0
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and can_jump:
		can_jump = false
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * current_speed
		
		# Gradually reduce the dash speed to the normal speed
		if current_speed > SPEED:
			current_speed = move_toward(current_speed, SPEED, DASH_RESISTANCE*delta)
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
	
	# TODO: Check the direction of the dash
	if Input.is_action_just_pressed("dash") and can_dash:
		can_dash = false
		current_speed = DASH_SPEED
	
	move_and_slide()
