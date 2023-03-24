extends Node2D

@export var bulletSpeed: int = 300
@export var bulletScene: PackedScene

func shoot():
	var shoot = Input.is_action_just_pressed('shoot')
	
	if shoot:
		var newBullet: CharacterBody2D = bulletScene.instantiate()
		var mousePos = $Player.get_local_mouse_position().normalized()
		newBullet.position = $Player.position
		newBullet.velocity = mousePos * bulletSpeed
		add_child(newBullet)

func _process(delta):
	shoot()
