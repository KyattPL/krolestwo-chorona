extends CharacterBody2D

@export var jump_speed: int = -400
@export var run_speed: int = 300
@export var joystick_sens: int = 700

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jumping = false
enum SPELLS { NONE, FIRE, WATER, LIGHTNING, EARTH }
var selectedSpell: SPELLS = SPELLS.NONE

func select_spell():
	if Input.is_action_just_pressed("select_fire"):
		selectedSpell = SPELLS.FIRE if selectedSpell != SPELLS.FIRE else SPELLS.NONE
	if Input.is_action_just_pressed("select_water"):
		selectedSpell = SPELLS.WATER if selectedSpell != SPELLS.WATER else SPELLS.NONE
	if Input.is_action_just_pressed("select_lightning"):
		selectedSpell = SPELLS.LIGHTNING if selectedSpell != SPELLS.LIGHTNING else SPELLS.NONE
	if Input.is_action_just_pressed("select_earth"):
		selectedSpell = SPELLS.EARTH if selectedSpell != SPELLS.EARTH else SPELLS.NONE

func joystick_aim(delta):
	var direction: Vector2
	direction.x = Input.get_action_strength("aim_right") - Input.get_action_strength("aim_left")
	direction.y = Input.get_action_strength("aim_down") - Input.get_action_strength("aim_up")
	
	if abs(direction.x) == 1 and abs(direction.y) == 1:
		direction = direction.normalized()

	var movement = joystick_sens * direction * delta
	if (movement):  
		get_viewport().warp_mouse(get_global_mouse_position() + movement) 

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
	velocity.y += gravity * delta
	if jumping and is_on_floor():
		jumping = false
		
	move_and_slide()

func _process(delta):
	select_spell()
	joystick_aim(delta)
	get_input()
	$AnimatedSprite2D.flip_h = velocity.x < 0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
