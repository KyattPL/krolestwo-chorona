extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var speed = 200
@export var bulletSpeed = 200
@export var bulletScene: PackedScene

var facingLeft: bool = false
var fightVelocity: float = 0.0
var isShielded: bool = false


enum SHIELD_TYPE { FIRE, WATER, LIGHTNING, EARTH }
var currentShield: SHIELD_TYPE
# PATROL - out of combat movement, FIGHT_MOVE - in combat with player tracking
# SHIELD - put on shield animation, SHOOT - stand still and shoot animation
enum STATE { PATROL, SHOOT, FIGHT_MOVE, SHIELD }

var currentState: STATE = STATE.PATROL

func _physics_process(delta):
	match currentState:
		STATE.PATROL:
			patrol(delta)
		STATE.FIGHT_MOVE:
			fight_move()

func patrol(delta):
	velocity.x = -speed if facingLeft else speed
	velocity.y += gravity * delta
	
	move_and_slide()
	detect_turn_around()

func shoot():
	var playerObj: CharacterBody2D = get_node("../PlayerRoot/Player")
	var bulletInstance: CharacterBody2D = bulletScene.instantiate()
	var aimPlayerVec  = Vector2(playerObj.position.x - position.x, playerObj.position.y - position.y)
	
	bulletInstance.position = position
	bulletInstance.velocity = aimPlayerVec.normalized() * bulletSpeed
	add_sibling(bulletInstance)
	currentState = STATE.FIGHT_MOVE

func fight_move():
	velocity.x = fightVelocity
	if not $GroundRayCast.is_colliding() and is_on_floor():
		velocity.x = 30 if facingLeft else -30
		
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
			$Shield.modulate = Color.YELLOW
			currentShield = SHIELD_TYPE.LIGHTNING
		_:
			$Shield.modulate = Color.GREEN
			currentShield = SHIELD_TYPE.EARTH
	isShielded = true
	$Shield.visible = true

func detect_turn_around():
	if not $GroundRayCast.is_colliding() and is_on_floor():
		facingLeft = !facingLeft
		scale.x = -scale.x

func _on_player_detector_body_entered(_body: CharacterBody2D):
	currentState = STATE.FIGHT_MOVE
	$StateChangeTimer.start()
	$LoseAggroTimer.stop()

func _on_player_detector_body_exited(_body):
	$LoseAggroTimer.start()

func _on_state_change_timer_timeout():
	var choice = randf()
	
	if choice < 0.8:
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