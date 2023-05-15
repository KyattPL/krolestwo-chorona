extends CharacterBody2D

@export var damage = 20
const ENEMY_COLLISION_LAYER: int = 8

enum SPELL { NONE, FIRE, WATER, LIGHTNING, EARTH }

var hitObject = false
var isBest = false

func max_lvl_increase(isMax):
	if isMax:
		damage += 20
		isBest = true

func _ready():
	$AnimationPlayer.play("fly")

func _physics_process(delta):
	if !hitObject:
		move_and_slide()
	
	for i in get_slide_collision_count():
		var collision: KinematicCollision2D = get_slide_collision(i)
		if !hitObject and collision.get_collider().is_class("CharacterBody2D") and not is_queued_for_deletion():
			var character: CharacterBody2D = collision.get_collider()
			if character.get_collision_layer() == ENEMY_COLLISION_LAYER:
				character.got_hit(damage, SPELL.FIRE)
				if isBest:
					$BasicBolt.visible = false
					$BestBolt.visible = true
					$AnimationPlayer.play("splash_best")
				else:
					$AnimationPlayer.play("splash_basic")
				hitObject = true
				await $AnimationPlayer.animation_finished
				queue_free()
		if !hitObject and collision.get_collider().is_class("TileMap") and not is_queued_for_deletion():
			if isBest:
				$BasicBolt.visible = false
				$BestBolt.visible = true
				$AnimationPlayer.play("splash_best")
			else:
				$AnimationPlayer.play("splash_basic")
			hitObject = true
			await $AnimationPlayer.animation_finished
			queue_free()
