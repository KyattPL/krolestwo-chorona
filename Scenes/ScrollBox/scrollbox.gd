extends CanvasLayer

func _on_button_pressed():
	get_tree().paused = false
	visible = false
