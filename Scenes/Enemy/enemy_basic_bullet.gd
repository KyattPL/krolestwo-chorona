extends CharacterBody2D

@export var damage = 10
const PLAYER_COLLISION_LAYER: int = 1

var hitObject = false

func _ready():
	$BasicBolt.visible = true
	$BasicBoltHit.visible = false
	$AnimationPlayer.play("fly")

func _physics_process(delta):
	if !hitObject:
		move_and_slide()
	
	for i in get_slide_collision_count():
		var collision: KinematicCollision2D = get_slide_collision(i)
		if !hitObject and collision.get_collider().is_class("CharacterBody2D") and not is_queued_for_deletion():
			var character: CharacterBody2D = collision.get_collider()
			if character.get_collision_layer() == PLAYER_COLLISION_LAYER:
				character.got_hit(damage)
				$AudioStreamPlayer.stream = preload("res://Assets/spells/normal/basic_spell_hit.wav")
				$AudioStreamPlayer.play()
				$BasicBolt.visible = false
				$BasicBoltHit.visible = true
				$AnimationPlayer.play("hit")
				hitObject = true
				await $AnimationPlayer.animation_finished
				queue_free()
		if !hitObject and collision.get_collider().is_class("TileMap") and not is_queued_for_deletion():
			$AudioStreamPlayer.stream = preload("res://Assets/spells/normal/basic_spell_hit.wav")
			$AudioStreamPlayer.play()
			$BasicBolt.visible = false
			$BasicBoltHit.visible = true
			$AnimationPlayer.play("hit")
			hitObject = true
			await $AnimationPlayer.animation_finished
			queue_free()
