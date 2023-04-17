extends Node2D

@export var bulletSpeed: int = 300
@export var normalSpell: PackedScene

@export var fireSpell: PackedScene
@export var waterSpell: PackedScene
@export var lightningSpell: PackedScene
@export var earthSpell: PackedScene

enum SPELL { NONE, FIRE, WATER, LIGHTNING, EARTH }

func spawn_bullet(bulletInstance: CharacterBody2D):
	var mousePos = $Player.get_local_mouse_position().normalized()
	bulletInstance.position = $Player.position
	bulletInstance.velocity = mousePos * bulletSpeed
	add_child(bulletInstance)

func shoot():
	var isShot = Input.is_action_just_pressed('shoot')
	
	if isShot and not $Player.isShielded:
		match $Player.selectedSpell:
			SPELL.FIRE:
				var fireBullet: CharacterBody2D = fireSpell.instantiate()
				$FireSpellCD.start()
				$Player.isFireOnCD = true
				$Player.selectedSpell = SPELL.NONE
				spawn_bullet(fireBullet)
			SPELL.WATER:
				var waterBullet: CharacterBody2D = waterSpell.instantiate()
				$WaterSpellCD.start()
				$Player.isWaterOnCD = true
				$Player.selectedSpell = SPELL.NONE
				spawn_bullet(waterBullet)
			SPELL.LIGHTNING:
				var lightningBullet: CharacterBody2D = lightningSpell.instantiate()
				$LightningSpellCD.start()
				$Player.isLightningOnCD = true
				$Player.selectedSpell = SPELL.NONE
				spawn_bullet(lightningBullet)
			SPELL.EARTH:
				var earthBullet: CharacterBody2D = earthSpell.instantiate()
				$EarthSpellCD.start()
				$Player.isEarthOnCD = true
				$Player.selectedSpell = SPELL.NONE
				spawn_bullet(earthBullet)
			_:			
				if not $Player.isNormalOnCD:
					var normalBullet: CharacterBody2D = normalSpell.instantiate()
					$NormalSpellCD.start()
					$Player.isNormalOnCD = true
					spawn_bullet(normalBullet)

func _process(delta):
	shoot()
