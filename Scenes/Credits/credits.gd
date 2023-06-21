extends Control

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_button_pressed():
	$ButtonClickPlayer.play()
	get_tree().change_scene_to_file("res://Scenes/MainMenu/main_menu.tscn")
