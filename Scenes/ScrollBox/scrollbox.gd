extends CanvasLayer

@export var joystick_sens = 700

signal resume_game

func _on_button_pressed():
	$ButtonClickPlayer.play()
	get_tree().paused = false
	visible = false
	resume_game.emit()

# probably should hide the crosshair and scroll the text?
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

func _process(delta):
	joystick_aim(delta)
	if Input.is_action_just_pressed("confirm"):
			get_tree().paused = false
			visible = false
			resume_game.emit()
