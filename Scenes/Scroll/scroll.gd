extends Node2D

var isPlayerOn: bool = false

func _process(delta):
	if Input.is_action_just_pressed("interact") and isPlayerOn:
		$Scrollbox.visible = true
		get_tree().paused = true

func _on_area_2d_body_entered(body: Node2D):
	if is_instance_of(body, CharacterBody2D):
		$ActionTooltip.visible = true
		isPlayerOn = true

func _on_area_2d_body_exited(body: Node2D):
	if is_instance_of(body, CharacterBody2D):
		$ActionTooltip.visible = false
		isPlayerOn = false
