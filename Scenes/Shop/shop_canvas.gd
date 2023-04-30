extends CanvasLayer

@export var joystick_sens = 700

var items = {
	1: {
		"name": "Health potion",
		"desc": "Restores 20HP",
		"price": 25
	},
	2: {
		"name": "Speed potion",
		"desc": "Increases speed for 10s",
		"price": 30
	},
	3: {
		"name": "Cooldown potion",
		"desc": "Reduces cooldown of spells by 30%",
		"price": 50
	}
}

var currentItem = 1

signal resume_game

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

func _ready():
	pass

func _process(delta):
	joystick_aim(delta)

func _on_close_shop_pressed():
	get_tree().paused = false
	resume_game.emit()
