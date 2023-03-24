extends Node2D

@export var bulletSpeed: int = 300
@export var bulletScene: PackedScene

enum SPELL { NONE, FIRE, WATER, LIGHTNING, EARTH }

func shoot():
	var isShot = Input.is_action_just_pressed('shoot')
	
	if isShot:
		
		# idk chyba 4 osobne sceny dla każdego spella
		# (choć ulepszenia w drzewku też mają to zmieniać to nwm)
		match $Player.selectedSpell:
			SPELL.FIRE:
				# fireBall.instantiate()
				# position i velocity tak jak niżej i dodawane do sceny
				# tylko jak z tymi ulepszeniami hmmmmm
				pass
			_:
				pass
		
		var newBullet: CharacterBody2D = bulletScene.instantiate()
		var mousePos = $Player.get_local_mouse_position().normalized()
		newBullet.position = $Player.position
		newBullet.velocity = mousePos * bulletSpeed
		add_child(newBullet)

func _process(delta):
	shoot()
