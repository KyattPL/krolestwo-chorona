extends Node2D

func _ready():
	$AnimatedSprite2D.play("default")

func _on_area_2d_body_entered(body: CharacterBody2D):
	body.got_coin()
	queue_free()
