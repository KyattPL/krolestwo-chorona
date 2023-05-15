extends CharacterBody2D

@export var jump_speed: int = -400
@export var run_speed: int = 200
@export var joystick_sens: int = 700

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jumping = false
var facingLeft = false

enum SPELL { NONE, FIRE, WATER, LIGHTNING, EARTH }
var selectedSpell: SPELL = SPELL.NONE
signal spell_selected(oldVal, newVal)

var maxHealth = 100
var health = 100
signal health_changed(oldVal, newVal)

var coins = 0
signal coins_changed(oldVal, newVal)

var healthPotions = 0
var speedPotions = 0
var cooldownPotions = 0
signal used_potion(potionType)

var skillPoints = 0
var fireLvl = 1
var waterLvl = 1
var lightningLvl = 1
var earthLvl = 1

var isFireOnCD: bool = false
var isWaterOnCD: bool = false
var isLightningOnCD: bool = false
var isEarthOnCD: bool = false
var isNormalOnCD: bool = false

var isShielded: bool = false

func select_spell():
	if Input.is_action_just_pressed("select_fire") and not isFireOnCD:
		spell_selected.emit(selectedSpell, SPELL.FIRE)
		selectedSpell = SPELL.FIRE if selectedSpell != SPELL.FIRE else SPELL.NONE
	if Input.is_action_just_pressed("select_water") and not isWaterOnCD:
		spell_selected.emit(selectedSpell, SPELL.WATER)
		selectedSpell = SPELL.WATER if selectedSpell != SPELL.WATER else SPELL.NONE
	if Input.is_action_just_pressed("select_lightning") and not isLightningOnCD:
		spell_selected.emit(selectedSpell, SPELL.LIGHTNING)
		selectedSpell = SPELL.LIGHTNING if selectedSpell != SPELL.LIGHTNING else SPELL.NONE
	if Input.is_action_just_pressed("select_earth") and not isEarthOnCD:
		spell_selected.emit(selectedSpell, SPELL.EARTH)
		selectedSpell = SPELL.EARTH if selectedSpell != SPELL.EARTH else SPELL.NONE

func joystick_aim(delta):
	var direction: Vector2
	direction.x = Input.get_action_strength("aim_right") - Input.get_action_strength("aim_left")
	direction.y = Input.get_action_strength("aim_down") - Input.get_action_strength("aim_up")
	
	direction = direction.normalized()
	#if abs(direction.x) == 1 and abs(direction.y) == 1:
	#	direction = direction.normalized()

	var movement = joystick_sens * direction * delta
	if (movement):
		get_viewport().warp_mouse(get_viewport().get_mouse_position() + movement) 

func get_input():
	velocity.x = 0
	var right = Input.is_action_pressed('move_right')
	var left = Input.is_action_pressed('move_left')
	var jump = Input.is_action_just_pressed('jump')
	var shield = Input.is_action_pressed("shield")
	
	var hpPotion = Input.is_action_just_pressed('use_health_potion')
	var speedPotion = Input.is_action_just_pressed('use_speed_potion')
	var cooldownPotion = Input.is_action_just_pressed('use_cooldown_potion')

	if shield and is_on_floor():
		isShielded = true
		$Shield.visible = true
		return
	else:
		$Shield.visible = false
		isShielded = false
	
	if jump and is_on_floor():
		jumping = true
		velocity.y = jump_speed
		
	if right and left:
		pass
	elif right:
		facingLeft = false
		velocity.x += run_speed
	elif left:
		facingLeft = true
		velocity.x -= run_speed
	
	if hpPotion and healthPotions > 0:
		var oldVal = health
		healthPotions -= 1
		health += 20
		used_potion.emit(0)
		if health > maxHealth:
			health = maxHealth
		health_changed.emit(oldVal, health)
	
	if speedPotion and speedPotions > 0:
		speedPotions -= 1
		run_speed += 100
		used_potion.emit(1)
		await get_tree().create_timer(3.0).timeout
		run_speed -= 100
		
	if cooldownPotion and cooldownPotions > 0:
		cooldownPotions -= 1
		used_potion.emit(2)

func got_hit(damage):
	if not isShielded:
		health -= damage
		health_changed.emit(health + damage, health)
		if health <= 0:
			get_tree().reload_current_scene()

func got_coin():
	coins_changed.emit(coins, coins + 10)
	coins += 10

func _physics_process(delta):
	velocity.y += gravity * delta
	if jumping and is_on_floor():
		jumping = false
		
	move_and_slide()

func _process(delta):
	select_spell()
	joystick_aim(delta)
	get_input()
	$AnimatedSprite2D.flip_h = facingLeft

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _on_fire_spell_cd_timeout():
	isFireOnCD = false


func _on_water_spell_cd_timeout():
	isWaterOnCD = false


func _on_lightning_spell_cd_timeout():
	isLightningOnCD = false


func _on_earth_spell_cd_timeout():
	isEarthOnCD = false


func _on_normal_spell_cd_timeout():
	isNormalOnCD = false
