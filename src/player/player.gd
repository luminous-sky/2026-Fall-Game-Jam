class_name Player
extends CharacterBody2D

## The lowest y-level that the player can go to before being respawned
@export var kill_y: float = 800.0


const SPEED: float = 175.0
const JUMP_VELOCITY: float = -350.0

## THe player's gravity
const GRAVITY: float = 750.0

## How fast the player moves when dashing
const DASH_SPEED: float = 350.0

## How long the dash lasts for, in seconds
const DASH_TIME: float = 0.75
## How much the speed decreases by per second after a dash
const DASH_RESISTANCE: float = (DASH_SPEED - SPEED) / DASH_TIME

static var dash_cooldown: float = 2.0

## Grace time, in seconds, before the player cannot jump after falling
const FALL_GRACE_TIME: float = 0.15

# Current fall time
var fall_time: float = 0.0
var can_jump: bool = true

# Current dash cooldown time
static var cooldown_time: float = 0.0

# Current launch velocity to be added
var current_launch: Vector2 = Vector2.ZERO

# Current horizontal movement speed
var current_speed: float = SPEED
var can_dash: bool = true
var last_direction: float = 0.0

# Current vertical movement speed
var current_fall_speed: float = 0.0
var is_landing: bool = false

var can_move: bool = true

@onready var default_camera_bounds: Array = [
	$Camera2D.limit_left,
	$Camera2D.limit_right,
	$Camera2D.limit_top,
	$Camera2D.limit_bottom,
]

@onready var default_camera_zoom = $Camera2D.zoom

@onready var footsteps_sfx: AudioStreamPlayer2D = $FootstepsSnow

func _ready() -> void:
	# Reset the cooldown
	cooldown_time = 0.0
	
	# Check if the parent is a level to constrain the camera
	if get_parent() is Level:
		var level: Level = get_parent()
		
		$Camera2D.limit_left = level.left_bound
		$Camera2D.limit_right = level.right_bound
		$Camera2D.limit_top = level.upper_bound
		$Camera2D.limit_bottom = level.lower_bound
		
		if level.zoom_override > 0.0:
			$Camera2D.zoom = level.zoom_override * Vector2(1, 1)
		else:
			$Camera2D.zoom = default_camera_zoom
		
		
		# Select footstep sound effect
		if level.current_area == GameData.AREAS.MAIN or level.current_area == GameData.AREAS.INTRO:
			footsteps_sfx = $FootstepsSnow
		elif level.current_area == GameData.AREAS.FINAL:
			footsteps_sfx = $FootstepsMetal


func _physics_process(delta: float) -> void:
	if not can_move:
		if footsteps_sfx.playing:
			footsteps_sfx.stop()
		
		return
	
	# Reset dash after the cooldown is over
	if not can_dash:
		cooldown_time += delta
		if cooldown_time >= dash_cooldown:
			can_dash = true
			cooldown_time = 0.0
	
	# Add the gravity.
	if not is_on_floor():
		current_fall_speed += GRAVITY * delta
		
		# Prevent jumping after the coyote time
		fall_time += delta
		if fall_time >= FALL_GRACE_TIME:
			can_jump = false
	else:
		# Check if a landing was done
		if fall_time > 0:
			is_landing = true
			
			if last_direction >= 0:
				$AnimatedSprite2D.play("land_right")
			else:
				$AnimatedSprite2D.play("land_left")
		
		# Reset the jump grace period
		can_jump = true
		fall_time = 0.0
		
		current_fall_speed = 0.0
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and can_jump:
		can_jump = false
		current_fall_speed = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		last_direction = direction
		velocity.x = direction * current_speed
		
		# Gradually reduce the dash speed to the normal speed
		if current_speed > SPEED:
			current_speed = move_toward(current_speed, SPEED, DASH_RESISTANCE*delta)
		
		# Play animations
		if not velocity.y and not is_landing:
			var anim_name: String = "run_"
			if current_speed > SPEED:
				anim_name = "dash_"
			
			if direction > 0:
				anim_name += "right"
			else:
				anim_name += "left"
			
			$AnimatedSprite2D.play(anim_name)
			
			if not footsteps_sfx.playing:
				footsteps_sfx.play()
		else:
			if footsteps_sfx.playing:
				footsteps_sfx.stop()
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		
		if not is_landing:
			if last_direction >= 0:
				$AnimatedSprite2D.play("idle_right")
			else:
				$AnimatedSprite2D.play("idle_left")
			
			if footsteps_sfx.playing:
				footsteps_sfx.stop()
	
	# Set y velocity
	velocity.y = current_fall_speed
	
	if Input.is_action_just_pressed("dash") and can_dash:
		var dash_y: float = int(Input.is_action_pressed("dash_up"))
		
		# Only disable dashing if the player dashes in the air
		if not is_on_floor():
			can_dash = false
		current_speed = DASH_SPEED
		current_fall_speed = -dash_y * DASH_SPEED
		
		# Launch velocity is cancelled out
		current_launch = Vector2.ZERO
		
		# Play audio
		$Dash.play()
	
	# Add launch velocity
	velocity.x += current_launch.x
	velocity.y += current_launch.y
	
	# Clamp final velocity
	#if abs(velocity.y) >= 600.0:
		#velocity.y = sign(velocity.y) * 600.0
	
	# Play vertical animations
	if velocity.y < 0:
		if last_direction >= 0:
			$AnimatedSprite2D.play("jump_right")
		else:
			$AnimatedSprite2D.play("jump_left")
	elif velocity.y > 0:
		if last_direction >= 0:
			$AnimatedSprite2D.play("fall_right")
		else:
			$AnimatedSprite2D.play("fall_left")
	
	# Gradually reduce launch velocity
	current_launch.x = move_toward(current_launch.x, 0, Orb.LAUNCH_RESISTANCE * delta)
	current_launch.y = move_toward(current_launch.y, 0, Orb.LAUNCH_RESISTANCE * delta)
	
	move_and_slide()

	if global_position.y > kill_y:
		respawn()
	
	# Reset launch velocity as needed
	if is_on_floor() or is_on_wall():
		current_launch = Vector2.ZERO


func respawn() -> void:
	get_tree().call_deferred("reload_current_scene")
	cooldown_time = 0.0


func _on_animated_sprite_2d_animation_finished() -> void:
	if is_landing:
		is_landing = false
