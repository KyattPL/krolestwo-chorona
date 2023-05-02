extends CanvasLayer

@export var joystick_sens = 700

var items = {
	0: {
		"name": "Health potion",
		"desc": "Restores 20HP",
		"price": 2
	},
	1: {
		"name": "Speed potion",
		"desc": "Increases speed for 3s",
		"price": 2
	},
	2: {
		"name": "Cooldown potion",
		"desc": "Refreshes cooldown of spells",
		"price": 3
	}
}

var currentItem = 0
var playersCoins = 0

var boughtHP = 0
var boughtSpeed = 0
var boughtCD = 0

signal resume_game
signal change_coins(newCoins)
signal add_potions(potionType, potionCount)

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

func set_players_coins(coins):
	playersCoins = coins
	boughtCD = 0
	boughtHP = 0
	boughtSpeed = 0

func change_item():
	var itemData = items[currentItem]
	$ItemNameContainer/ItemNameLabel.text = "[center]" + itemData['name'] + "[/center]"
	$ItemDescriptionContainer/ItemDescriptionLabel.text = "[center]" + itemData['desc'] + "[/center]"
	$ItemCostContainer/ItemCostLabel.text = "[center]" + str(itemData['price']) + " gold[/center]"
	$ItemSelectContainer/ItemIcon/MarginContainer/TextureRect.texture = load('res://Assets/shop/potion_' + str(currentItem) + '.png')

func _process(delta):
	joystick_aim(delta)

func _on_close_shop_pressed():
	var playerNode = get_node("../../PlayerRoot/Player")
	get_tree().paused = false
	change_coins.emit(playersCoins)
	if boughtHP > 0:
		add_potions.emit(0, boughtHP)
	if boughtSpeed > 0:
		add_potions.emit(1, boughtSpeed)
	if boughtCD > 0:
		add_potions.emit(2, boughtCD)
	resume_game.emit()

func _on_next_item_button_pressed():
	currentItem = (currentItem + 1) % 3
	change_item()

func _on_prev_item_button_pressed():
	currentItem -= 1
	if currentItem == -1:
		currentItem = 2
	currentItem %= 3
	change_item()

func _on_buy_button_pressed():
	if playersCoins >= items[currentItem]['price']:
		playersCoins -= items[currentItem]['price']
		$MoneyContainer/MoneyLabel.text = "[center]Money: " + str(playersCoins) + "[/center]"
		match currentItem:
			0:
				boughtHP += 1
			1:
				boughtSpeed += 1
			2:
				boughtCD += 1
