extends Node2D


func _ready():
	$AnimationPlayer.play("idle")

func _on_area_2d_body_entered(body: CharacterBody2D):
	$AnimationPlayer.play("destroyed")
	body.queue_free()
	await $AnimationPlayer.animation_finished
	queue_free()
