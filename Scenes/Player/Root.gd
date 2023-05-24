extends Node2D

@export var bulletSpeed: int = 200
@export var normalSpell: PackedScene

@export var fireSpell: PackedScene
@export var waterSpell: PackedScene
@export var lightningSpell: PackedScene
@export var earthSpell: PackedScene

enum SPELL { NONE, FIRE, WATER, LIGHTNING, EARTH }

signal fireOnCD(waitTime)
signal waterOnCD(waitTime)
signal lightningOnCD(waitTime)
signal earthOnCD(waitTime)

func spawn_bullet(bulletInstance: CharacterBody2D):
	var mousePos = $Player.get_local_mouse_position().normalized()
	bulletInstance.position = $Player.position
	bulletInstance.velocity = mousePos * bulletSpeed
	add_child(bulletInstance)

func play_cast_audio():
	$AudioStreamPlayer.stream = preload("res://Assets/wizard/56_Attack_03.wav")
	$AudioStreamPlayer.play()

func shoot():
	var isShot = Input.is_action_just_pressed('shoot')
	
	if isShot and not $Player.isShielded:
		match $Player.selectedSpell:
			SPELL.FIRE:
				var fireBullet: CharacterBody2D = fireSpell.instantiate()
				fireBullet.max_lvl_increase($Player.fireLvl == 3)
				$FireSpellCD.start()
				fireOnCD.emit($FireSpellCD.wait_time)
				$Player.isFireOnCD = true
				$Player.selectedSpell = SPELL.NONE
				play_cast_audio()
				spawn_bullet(fireBullet)
			SPELL.WATER:
				var waterBullet: CharacterBody2D = waterSpell.instantiate()
				waterBullet.max_lvl_increase($Player.waterLvl == 3)
				$WaterSpellCD.start()
				waterOnCD.emit($WaterSpellCD.wait_time)
				$Player.isWaterOnCD = true
				$Player.selectedSpell = SPELL.NONE
				play_cast_audio()
				spawn_bullet(waterBullet)
			SPELL.LIGHTNING:
				var lightningBullet: CharacterBody2D = lightningSpell.instantiate()
				lightningBullet.max_lvl_increase($Player.lightningLvl == 3)
				$LightningSpellCD.start()
				lightningOnCD.emit($LightningSpellCD.wait_time)
				$Player.isLightningOnCD = true
				$Player.selectedSpell = SPELL.NONE
				play_cast_audio()
				spawn_bullet(lightningBullet)
			SPELL.EARTH:
				var earthBullet: CharacterBody2D = earthSpell.instantiate()
				earthBullet.max_lvl_increase($Player.earthLvl == 3)
				$EarthSpellCD.start()
				earthOnCD.emit($EarthSpellCD.wait_time)
				$Player.isEarthOnCD = true
				$Player.selectedSpell = SPELL.NONE
				play_cast_audio()
				spawn_bullet(earthBullet)
			_:			
				if not $Player.isNormalOnCD:
					var normalBullet: CharacterBody2D = normalSpell.instantiate()
					$NormalSpellCD.start()
					$Player.isNormalOnCD = true
					play_cast_audio()
					spawn_bullet(normalBullet)

func _process(delta):
	shoot()


func _on_scroll_pause_game():
	$HUD.visible = false


func _on_scroll_resume_game():
	$HUD.visible = true


func _on_shop_pause_game():
	$HUD.visible = false

	
func _on_shop_resume_game():
	$HUD.visible = true

func _on_shop_change_coins(newCoins):
	$HUD/HUD/Stats/CoinsText.text = str(newCoins)
	$Player.coins = newCoins

func _on_shop_add_potions(potionType, potionCount):
	match potionType:
		0:
			$Player.healthPotions += potionCount
			$HUD/HUD/Items/HealthPotionBox/HealthPotionTextBox/HealthPotionCount.text = str($Player.healthPotions)
		1:
			$Player.speedPotions += potionCount
			$HUD/HUD/Items/SpeedPotionBox/SpeedPotionTextBox/SpeedPotionCount.text = str($Player.speedPotions)
		2:
			$Player.cooldownPotions += potionCount
			$HUD/HUD/Items/CooldownPotionBox/CooldownPotionTextBox/CooldownPotionCount.text = str($Player.cooldownPotions)
