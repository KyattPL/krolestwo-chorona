extends Control


func _on_play_button_pressed():
	if not FileAccess.file_exists("user://savegame.save"):
		get_tree().change_scene_to_file("res://Scenes/Level1/level_1.tscn")
	else:
		var restoredSave = FileAccess.open("user://savegame.save", FileAccess.READ)
		var jsonData = restoredSave.get_line()
		var json = JSON.new()
		var parsedJson = json.parse(jsonData)
		if not parsedJson == OK:
			print("JSON PARSE ERROR: ", json.get_error_message())
			
		var data = json.get_data()
		var currentLvl = data['gameLvl']
		get_tree().change_scene_to_file("res://Scenes/Level" + str(currentLvl)
			+ "/level_" + str(currentLvl) + ".tscn")

func _on_settings_button_pressed():
	$MarginButtonsContainer.visible = false
	$MarginSettingsContainer.visible = true
	
func _on_exit_button_pressed():
	get_tree().quit()

func _on_return_button_pressed():
	$MarginSettingsContainer.visible = false
	$MarginButtonsContainer.visible = true

func _on_reset_button_pressed():
	$MarginSettingsContainer.visible = false
	$MarginResetContainer.visible = true

func _on_reset_cancel_button_pressed():
	$MarginSettingsContainer.visible = true
	$MarginResetContainer.visible = false

func _on_reset_confirm_button_pressed():
	DirAccess.remove_absolute("user://savegame.save")
	$MarginSettingsContainer.visible = true
	$MarginResetContainer.visible = false
