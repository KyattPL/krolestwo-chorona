extends CanvasLayer

@export var joystick_sens = 700

signal resume_game

func _on_close_shop_pressed():
	get_tree().paused = false
	resume_game.emit()

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	joystick_aim(delta)
