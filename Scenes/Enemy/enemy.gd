extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var speed = 200

var facingLeft: bool = false

# PATROL - out of combat movement, FIGHT_MOVE - in combat with player tracking
# SHIELD - put on shield animation, SHOOT - stand still and shoot animation
enum STATE { PATROL, SHOOT, FIGHT_MOVE, SHIELD }

var currentState: STATE = STATE.PATROL

func _physics_process(delta):
	match currentState:
		STATE.PATROL:
			patrol(delta)

func patrol(delta):
	velocity.x = -speed if facingLeft else speed
	velocity.y += gravity * delta
	
	move_and_slide()
	detect_turn_around()

func shoot():
	# idk play shoot animation and spawn 0.5s timer of idling
	# after the timer is done the state should be changed to FIGHT_MOVE	
	pass

func fight_move():
	pass

func detect_turn_around():
	if not $GroundRayCast.is_colliding() and is_on_floor():
		facingLeft = !facingLeft
		scale.x = -scale.x

func _on_player_detector_body_entered(body):
	currentState = STATE.SHOOT
	print("Shoot!")
