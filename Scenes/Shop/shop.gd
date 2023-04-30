extends Node2D

var isPlayerOn: bool = false

signal pause_game
signal resume_game
signal change_coins(newCoins)
signal add_potions(potionType, potionCount)

func _process(delta):
	if Input.is_action_just_pressed("interact") and isPlayerOn:
		$ActionTooltip.visible = false
		$ShopCanvas/AnimationPlayer.play("TransitionIn")
		var playersCoins = get_node("../PlayerRoot/Player").coins
		$ShopCanvas.set_players_coins(playersCoins)
		$ShopCanvas/MoneyContainer/MoneyLabel.text = "[center]Money: " + str(playersCoins) + "[/center]"
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


func _on_shop_canvas_change_coins(newCoins):
	change_coins.emit(newCoins)

func _on_shop_canvas_add_potions(potionType, potionCount):
	add_potions.emit(potionType, potionCount)
