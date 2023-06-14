extends CharacterBody2D

@export var damage = 10
const PLAYER_COLLISION_LAYER: int = 1

func _physics_process(delta):
	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision: KinematicCollision2D = get_slide_collision(i)
		if collision.get_collider().is_class("CharacterBody2D") and not is_queued_for_deletion():
			var character: CharacterBody2D = collision.get_collider()
			if character.get_collision_layer() == PLAYER_COLLISION_LAYER:
				character.got_hit(damage)
				queue_free()
		if collision.get_collider().is_class("TileMap") and not is_queued_for_deletion():
			queue_free()
