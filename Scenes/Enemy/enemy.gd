extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var speed = 200
@export var bulletSpeed = 200
@export var bulletScene: PackedScene

var facingLeft: bool = false

# PATROL - out of combat movement, FIGHT_MOVE - in combat with player tracking
# SHIELD - put on shield animation, SHOOT - stand still and shoot animation
enum STATE { PATROL, SHOOT, FIGHT_MOVE, SHIELD }

var currentState: STATE = STATE.PATROL

func _physics_process(delta):
	match currentState:
		STATE.PATROL:
			patrol(delta)
		STATE.SHOOT:
			shoot()
		STATE.FIGHT_MOVE:
			fight_move()
		STATE.SHIELD:
			shield()

func patrol(delta):
	velocity.x = -speed if facingLeft else speed
	velocity.y += gravity * delta
	
	move_and_slide()
	detect_turn_around()

func shoot():
	var playerObj: CharacterBody2D = get_tree().get_root().get_node("Player")
	var bulletInstance: CharacterBody2D = bulletScene.instantiate()
	var aimPlayerVec  = Vector2(playerObj.position.x - position.x, playerObj.position.y - position.y)
	
	bulletInstance.position = position
	bulletInstance.velocity = aimPlayerVec * bulletSpeed
	add_child(bulletInstance)
	$StateChangeTimer.start()

func fight_move():
	pass
	
func shield():
	pass

func detect_turn_around():
	if not $GroundRayCast.is_colliding() and is_on_floor():
		facingLeft = !facingLeft
		scale.x = -scale.x

func _on_player_detector_body_entered(body: CharacterBody2D):
	
	currentState = STATE.SHOOT

func _on_player_detector_body_exited(body):
	currentState = STATE.PATROL

func _on_state_change_timer_timeout():
	var choice = randf()
	
	if choice < 0.8:
		currentState = STATE.FIGHT_MOVE
	elif choice < 0.9:
		currentState = STATE.SHOOT
	else:
		currentState = STATE.SHIELD
