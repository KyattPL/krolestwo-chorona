extends Node2D


var isPlayerOn: bool = false

func _ready():
	$AnimationPlayer.play("default")

func _process(delta):
	if Input.is_action_just_pressed("interact") and isPlayerOn:
		var playerNode = get_node("../PlayerRoot/Player")
		var lvlNumber = int(get_tree().current_scene.name.right(1)) + 1
		var saveDict = {
			"gameLvl": lvlNumber,
			"coins": playerNode.coins,
			"healthPotions": playerNode.healthPotions,
			"speedPotions": playerNode.speedPotions,
			"cooldownPotions": playerNode.cooldownPotions,
			"skillPoints": playerNode.skillPoints,
			"fireLvl": playerNode.fireLvl,
			"waterLvl": playerNode.waterLvl,
			"lightningLvl": playerNode.lightningLvl,
			"earthLvl": playerNode.earthLvl,
		}
		var saveGame = FileAccess.open("user://savegame.save", FileAccess.WRITE)
		saveGame.store_line(JSON.stringify(saveDict))
		get_tree().change_scene_to_file("res://Scenes/Level" + str(lvlNumber) 
			+ "/level_" + str(lvlNumber) + ".tscn")

func _on_area_2d_body_entered(body):
	if is_instance_of(body, CharacterBody2D):
		$ActionTooltip.visible = true
		isPlayerOn = true

func _on_area_2d_body_exited(body):
	if is_instance_of(body, CharacterBody2D):
		$ActionTooltip.visible = false
		isPlayerOn = false
