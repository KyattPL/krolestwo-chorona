extends CharacterBody2D

@export var damage = 15
const ENEMY_COLLISION_LAYER: int = 8

enum SPELL { NONE, FIRE, WATER, LIGHTNING, EARTH }

var hitObject = false
var isBest = false

func max_lvl_increase(isMax):
	if isMax:
		damage += 20
		isBest = true
		
func _ready():
	if isBest:
		$BasicBolt.visible = false
		$BestBoltStart.visible = true
		$AnimationPlayer.play("best_start")
		await $AnimationPlayer.animation_finished
		$BestBoltStart.visible = false
		$BestBoltRepeat.visible = true
		$AnimationPlayer.play("best_fly")
	else:
		$AnimationPlayer.play("basic_start")
		await $AnimationPlayer.animation_finished
		$AnimationPlayer.play("basic_fly")

func _physics_process(delta):
	if !hitObject:
		move_and_slide()
	
	for i in get_slide_collision_count():
		var collision: KinematicCollision2D = get_slide_collision(i)
		if !hitObject and collision.get_collider().is_class("CharacterBody2D") and not is_queued_for_deletion():
			var character: CharacterBody2D = collision.get_collider()
			if character.get_collision_layer() == ENEMY_COLLISION_LAYER:
				character.got_hit(damage, SPELL.WATER)
				if isBest:
					$BestBoltRepeat.visible = false
					$BestBoltHit.visible = true
					$AudioStreamPlayer.stream = preload("res://Assets/spells/water/freeze2.wav")
					$AudioStreamPlayer.play()
					$AnimationPlayer.play("best_hit")
				else:
					$BasicBolt.visible = false
					$BasicBoltHit.visible = true
					$AudioStreamPlayer.stream = preload("res://Assets/spells/water/water.wav")
					$AudioStreamPlayer.play()
					$AnimationPlayer.play("basic_hit")
				hitObject = true
				await $AnimationPlayer.animation_finished
				queue_free()
		if !hitObject and collision.get_collider().is_class("TileMap") and not is_queued_for_deletion():
			if isBest:
				$BestBoltRepeat.visible = false
				$BestBoltHit.visible = true
				$AudioStreamPlayer.stream = preload("res://Assets/spells/water/freeze2.wav")
				$AudioStreamPlayer.play()
				$AnimationPlayer.play("best_hit")
			else:
				$BasicBolt.visible = false
				$BasicBoltHit.visible = true
				$AudioStreamPlayer.stream = preload("res://Assets/spells/water/water.wav")
				$AudioStreamPlayer.play()
				$AnimationPlayer.play("basic_hit")
			hitObject = true
			await $AnimationPlayer.animation_finished
			queue_free()
