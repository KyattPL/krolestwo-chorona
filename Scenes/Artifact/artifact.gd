extends Node2D


func _ready():
	$AnimationPlayer.play("idle")

func _on_area_2d_body_entered(body: CharacterBody2D):
	var playerNode = get_node("../PlayerRoot/Player")
	playerNode.artifacts += 1
	
	$AudioStreamPlayer.stream = preload("res://Assets/artifact/DeathFlash.wav")
	$AudioStreamPlayer.play()
	$AnimationPlayer.play("destroyed")
	body.queue_free()
	await $AnimationPlayer.animation_finished
	await $AudioStreamPlayer.finished
	queue_free()
