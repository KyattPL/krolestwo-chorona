extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var speed = 80
@export var maxHealth = 250
@export var bulletSpeed = 350
@export var bulletScene: PackedScene
@export var coinScene: PackedScene

var facingLeft: bool = false
var fightVelocity: float = 0.0
var isShielded: bool = false
var health: float

enum SPELL { NONE, FIRE, WATER, LIGHTNING, EARTH }

enum SHIELD_TYPE { FIRE, WATER, LIGHTNING, EARTH }
var currentShield: SHIELD_TYPE
# PATROL - out of combat movement, FIGHT_MOVE - in combat with player tracking
# SHIELD - put on shield animation, SHOOT - stand still and shoot animation
enum STATE { PATROL, SHOOT, FIGHT_MOVE, SHIELD, TELEPORT }

var currentState: STATE = STATE.PATROL

func _init():
	health = maxHealth

func _ready():
	$HealthUI/Healthbar.set_modulate(Color.from_hsv(100 / 255.0, 1, 0.72))

func _physics_process(delta):
	match currentState:
		STATE.PATROL:
			patrol(delta)
		STATE.FIGHT_MOVE:
			fight_move(delta)

func patrol(delta):
	velocity.x = -speed if facingLeft else speed
	velocity.y += gravity * delta
	
	move_and_slide()
	detect_turn_around()

func shoot():
	$AnimationPlayer.play("shoot")
	await $AnimationPlayer.animation_finished
	var playerObj: CharacterBody2D = get_node("../PlayerRoot/Player")
	var bulletInstance: CharacterBody2D = bulletScene.instantiate()
	var aimPlayerVec  = Vector2(playerObj.global_position.x - global_position.x, \
		playerObj.global_position.y - global_position.y)

	bulletInstance.position = position
	bulletInstance.velocity = aimPlayerVec.normalized() * bulletSpeed
	add_sibling(bulletInstance)
	currentState = STATE.FIGHT_MOVE

func fight_move(delta):
	if !($AnimationPlayer.current_animation == "shoot" and $AnimationPlayer.is_playing()):
		if fightVelocity == 0:
			$AnimationPlayer.play("idle")
		else:
			$AnimationPlayer.play("move")
	
	velocity.x = fightVelocity
	velocity.y += gravity * delta
	var playerObj: CharacterBody2D = get_node("../PlayerRoot/Player")
	var isPlayerOnLeft = playerObj.global_position.x < global_position.x
	if isPlayerOnLeft and not facingLeft:
		facingLeft = true
		$Sprite2D.flip_h = facingLeft
		$GroundRayCast.position.x = 47 if !facingLeft else -77
		$GroundRayCast2.position.x = -77 if !facingLeft else 47
		$PlayerDetector.position.x = 0 if !facingLeft else -1024
		
	if not isPlayerOnLeft and facingLeft:
		facingLeft = false
		$Sprite2D.flip_h = facingLeft
		$GroundRayCast.position.x = 47 if !facingLeft else -77
		$GroundRayCast2.position.x = -77 if !facingLeft else 47
		$PlayerDetector.position.x = 0 if !facingLeft else -1024
		
	if not $GroundRayCast.is_colliding() and is_on_floor():
		velocity.x = 30 if facingLeft else -30
		
	if not $GroundRayCast2.is_colliding() and is_on_floor():
		velocity.x = -30 if facingLeft else 30
		
	move_and_slide()

func fight_move_change_velocity():
	var velocitySign = -1 if randf() < 0.5 else 1
	fightVelocity = velocitySign * randf_range(50, 100)
	
func shield():
	var randomShield = randi_range(1, 4)
	match randomShield:
		1:
			$Shield.modulate = Color.RED
			currentShield = SHIELD_TYPE.FIRE
		2:
			$Shield.modulate = Color.BLUE
			currentShield = SHIELD_TYPE.WATER
		3:
			$Shield.modulate = Color.PURPLE
			currentShield = SHIELD_TYPE.LIGHTNING
		_:
			$Shield.modulate = Color.GREEN
			currentShield = SHIELD_TYPE.EARTH
	isShielded = true
	$Shield.visible = true

func teleport():
	var tpSpots = get_tree().get_nodes_in_group("bossTP")
	var numOfSpots = tpSpots.size()
	var randomSpotIndex = randi_range(0, numOfSpots - 1)
	var randomisedSpot = tpSpots[randomSpotIndex]
	global_position = randomisedSpot.global_position
	currentState = STATE.FIGHT_MOVE

func detect_turn_around():
	if (not $GroundRayCast.is_colliding() and is_on_floor()) or \
		($WallRayCast.is_colliding() or $WallRayCast2.is_colliding()):
		facingLeft = !facingLeft
		$Sprite2D.flip_h = facingLeft
		$GroundRayCast.position.x = 47 if !facingLeft else -77
		$GroundRayCast2.position.x = -77 if !facingLeft else 47
		$WallRayCast.position.x = 5 if !facingLeft else -45
		$WallRayCast.rotation_degrees = -90 if !facingLeft else 90
		$WallRayCast2.position.x = 5 if !facingLeft else -45
		$WallRayCast2.rotation_degrees = -90 if !facingLeft else 90
		$PlayerDetector.position.x = 0 if !facingLeft else -1024

func got_hit(damage, spellType):
	if isShielded:
		if currentShield == SHIELD_TYPE.FIRE and spellType == SPELL.FIRE \
			or currentShield == SHIELD_TYPE.WATER and spellType == SPELL.WATER \
			or currentShield == SHIELD_TYPE.LIGHTNING and spellType == SPELL.LIGHTNING \
			or currentShield == SHIELD_TYPE.EARTH and spellType == SPELL.EARTH:
				isShielded = false
				$Shield.visible = false
	else:
		health -= damage
		var percentRemaining = round((health / maxHealth) * 100)
		var newHue = percentRemaining / 255.0
		$HealthUI/Healthbar.value = percentRemaining
		$HealthUI/Healthbar.set_modulate(Color.from_hsv(newHue, 1, 0.72))
		if health <= 0:
			var spawnedCoin = coinScene.instantiate()
			spawnedCoin.scale = Vector2(0.02, 0.02)
			spawnedCoin.position = position
			get_node("../PlayerRoot/Player").skillPoints += 1
			get_node("../PlayerRoot/HUD/HUD/SkillTree/SkillTreeOpenBox/UnspentSkillPointsBox").visible = true
			get_node("..").add_child(spawnedCoin)
			queue_free()

func _on_player_detector_body_entered(_body: CharacterBody2D):
	currentState = STATE.FIGHT_MOVE
	$StateChangeTimer.start()
	$LoseAggroTimer.stop()

func _on_player_detector_body_exited(_body):
	$LoseAggroTimer.start()

func _on_state_change_timer_timeout():
	var choice = randf()
	
	if choice < 0.1:
		currentState = STATE.TELEPORT
		teleport()
	elif choice < 0.4:
		currentState = STATE.FIGHT_MOVE
		fightVelocity = 0
	elif choice < 0.8:
		currentState = STATE.FIGHT_MOVE
		fight_move_change_velocity()
	elif choice < 0.9 and !isShielded:
		currentState = STATE.SHIELD
		shield()
	else:
		currentState = STATE.SHOOT
		shoot()

func _on_lose_aggro_timer_timeout():
	currentState = STATE.PATROL
	$StateChangeTimer.stop()
