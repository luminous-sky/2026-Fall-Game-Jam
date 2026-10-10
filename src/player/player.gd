class_name Player
extends CharacterBody2D


const SPEED: float = 300.0
const JUMP_VELOCITY: float = -400.0

## Grace time, in seconds, before the player cannot jump after falling
const FALL_GRACE_TIME: float = 0.15

# Current fall time
var fall_time: float = 0.0
var can_jump: bool = true


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
		fall_time += delta
		if fall_time >= FALL_GRACE_TIME:
			can_jump = false
	else:
		can_jump = true
		fall_time = 0.0

	# Handle jump.
	if Input.is_action_just_pressed("jump") and can_jump:
		can_jump = false
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
