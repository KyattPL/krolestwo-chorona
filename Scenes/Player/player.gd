extends CharacterBody2D

@export var jump_speed: int = -400
@export var run_speed: int = 300

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jumping = false

func get_input():
	velocity.x = 0
	var right = Input.is_action_pressed('move_right')
	var left = Input.is_action_pressed('move_left')
	var jump = Input.is_action_just_pressed('jump')

	if jump and is_on_floor():
		jumping = true
		velocity.y = jump_speed
	if right:
		velocity.x += run_speed
	if left:
		velocity.x -= run_speed

func _physics_process(delta):
	get_input()
	# shoot()
	velocity.y += gravity * delta
	if jumping and is_on_floor():
		jumping = false
		
	move_and_slide()

func _process(delta):
	$AnimatedSprite2D.flip_h = velocity.x < 0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
