extends Node2D

@export_enum("npc1", "npc2") var dialogKey: String
var isPlayerOn: bool = false

func _ready():
	$DialogBox.dialogKey = dialogKey
	$DialogBox.load_json_data()

func _process(delta):
	if Input.is_action_just_pressed("interact") and isPlayerOn:
		$DialogBox.visible = true
		$ActionTooltip.visible = false
		get_node("../PlayerRoot/HUD").visible = false
		get_tree().paused = true

func _on_area_2d_body_entered(body):
	if is_instance_of(body, CharacterBody2D):
		$ActionTooltip.visible = true
		isPlayerOn = true

func _on_area_2d_body_exited(body):
	if is_instance_of(body, CharacterBody2D):
		$ActionTooltip.visible = false
		isPlayerOn = false
