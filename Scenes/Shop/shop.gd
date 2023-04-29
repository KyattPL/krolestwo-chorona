extends Node2D

var isPlayerOn: bool = false

signal pause_game
signal resume_game

func _process(delta):
	if Input.is_action_just_pressed("interact") and isPlayerOn:
		$ActionTooltip.visible = false
		$ShopCanvas/AnimationPlayer.play("TransitionIn")
		pause_game.emit()
		get_tree().paused = true

func _on_area_2d_body_entered(body: Node2D):
	if is_instance_of(body, CharacterBody2D):
		$ActionTooltip.visible = true
		isPlayerOn = true


func _on_area_2d_body_exited(body: Node2D):
	if is_instance_of(body, CharacterBody2D):
		$ActionTooltip.visible = false
		isPlayerOn = false

func _on_shop_canvas_resume_game():
	$ShopCanvas/AnimationPlayer.play("TransitionOut")
	$ActionTooltip.visible = true
	resume_game.emit()
