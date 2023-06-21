extends Node

func _on_boss_tree_exited():
	get_tree().change_scene_to_file("res://Scenes/Credits/credits.tscn")
