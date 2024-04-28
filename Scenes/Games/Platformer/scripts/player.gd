extends CharacterBody3D

signal coin_collected

@export_subgroup("Components")
@export var view: Node3D

@export_subgroup("Properties")
## Input action for movement direction
@export var left_controller_path : NodePath = '../../XROrigin3D/LeftHand'
@export var right_controller_path : NodePath = '../../XROrigin3D/RightHand'
@export var camera_path : NodePath = '../../XROrigin3D/XRCamera3D'
@export var movement_input_action : String = "primary"
@export var jump_input_action: String = "ax_button"
@export var movement_speed = 250
@export var jump_strength = 4

var _origin_position: Vector3
var _origin_rotation_y: float
var movement_velocity: Vector3
var rotation_direction: float
var gravity = 0

var previously_floored = false

var jump_is_pressed : bool = false
var jump_single : bool = true
var jump_double : bool = true

var coins = 0

@onready var particles_trail = $ParticlesTrail
@onready var sound_footsteps = $SoundFootsteps
@onready var model = $Character
@onready var animation = $Character/AnimationPlayer
# Controller node
@onready var _left_controller := XRHelpers.get_xr_controller(self, left_controller_path)
@onready var _right_controller := XRHelpers.get_xr_controller(self, right_controller_path)
@onready var _camera := XRHelpers.get_xr_camera(self, camera_path)


func _ready():
	_origin_position = position
	_origin_rotation_y = _camera.global_rotation.y
	
# Functions

func _physics_process(delta):
	
	# Handle functions
	
	handle_controls(delta)
	handle_gravity(delta)
	
	handle_effects()
	
	# Movement

	var applied_velocity: Vector3
	
	applied_velocity = velocity.lerp(movement_velocity, delta * 10)
	applied_velocity.y = -gravity
	
	velocity = applied_velocity
	move_and_slide()
	
	# Rotation
	
	if Vector2(velocity.z, velocity.x).length() > 0:
		rotation_direction = Vector2(velocity.z, velocity.x).angle()
		
	rotation.y = lerp_angle(rotation.y, rotation_direction, delta * 10)
	
	# Falling/respawning
	
	if position.y < -10:
		position = _origin_position
	
	# Animation for scale (jumping and landing)
	
	model.scale = model.scale.lerp(Vector3(1, 1, 1), delta * 10)
	
	# Animation when landing
	
	if is_on_floor() and gravity > 2 and !previously_floored:
		model.scale = Vector3(1.25, 0.75, 1.25)
		$SoundLand.play()
	
	previously_floored = is_on_floor()

# Handle animation(s)

func handle_effects():
	
	particles_trail.emitting = false
	sound_footsteps.stream_paused = true
	
	if is_on_floor():
		if abs(velocity.x) > .5 or abs(velocity.z) > .5:
			animation.play("walk", 0.5)
			particles_trail.emitting = true
			sound_footsteps.stream_paused = false
		else:
			animation.play("idle", 0.5)
	else:
		animation.play("jump", 0.5)

# Handle movement input

func handle_controls(delta):
	
	# Movement
	
	var input := Vector3.ZERO
	var dz_input_action = XRToolsUserSettings.get_adjusted_vector2(_left_controller, movement_input_action)
	input.x = dz_input_action.y
	input.z = dz_input_action.x

	input = input.rotated(Vector3.UP, (_camera.global_rotation.y - _origin_rotation_y)).normalized()
	
	movement_velocity = input * movement_speed * delta
	
	# Jumping
	if _is_jump_just_pressed():
		
		if jump_single or jump_double:
			$SoundJump.play()
		
		if jump_double:
			
			gravity = -jump_strength
			
			jump_double = false
			model.scale = Vector3(0.5, 1.5, 0.5)
			
		if(jump_single): jump()

func _is_jump_just_pressed() -> bool :
	var jump_was_pressed = jump_is_pressed
	jump_is_pressed = _right_controller.is_button_pressed(jump_input_action)
	
	return !jump_was_pressed and jump_is_pressed
# Handle gravity

func handle_gravity(delta):
	
	gravity += 25 * delta
	
	if gravity > 0 and is_on_floor():
		
		jump_single = true
		gravity = 0

# Jumping

func jump():
	
	gravity = -jump_strength
	
	model.scale = Vector3(0.5, 1.5, 0.5)
	
	jump_single = false;
	jump_double = true;

# Collecting coins

func collect_coin():
	
	coins += 1
	
	coin_collected.emit(coins)
