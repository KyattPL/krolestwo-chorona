extends Control

var loadedLvlName: String

func _ready():
	var sfxBusIndex = AudioServer.get_bus_index("SFX")
	var musicBusIndex = AudioServer.get_bus_index("Music")
	
	if not FileAccess.file_exists("user://savegame.save"):
		loadedLvlName = "res://Scenes/Level1/level_1.tscn"
	else:
		var restoredSave = FileAccess.open("user://savegame.save", FileAccess.READ)
		var jsonData = restoredSave.get_line()
		var json = JSON.new()
		var parsedJson = json.parse(jsonData)
		if not parsedJson == OK:
			print("JSON PARSE ERROR: ", json.get_error_message())
			
		var data = json.get_data()
		var currentLvl = data['gameLvl']
		loadedLvlName = "res://Scenes/Level" + str(currentLvl) \
			+ "/level_" + str(currentLvl) + ".tscn"
			
	var config = ConfigFile.new()
	var err = config.load("user://settings.cfg")
	
	if err != OK:
		AudioServer.set_bus_volume_db(sfxBusIndex, -30)
		AudioServer.set_bus_volume_db(musicBusIndex, -30)
		
		var configFile = ConfigFile.new()
		configFile.set_value("Audio", "sfxVol", -30)
		configFile.set_value("Audio", "musicVol", -30)
		configFile.save("user://settings.cfg")
	else:
		AudioServer.set_bus_volume_db(sfxBusIndex, config.get_value("Audio", "sfxVol"))
		AudioServer.set_bus_volume_db(musicBusIndex, config.get_value("Audio", "musicVol"))
	
	var sfxVolume = AudioServer.get_bus_volume_db(sfxBusIndex)
	var musicVolume = AudioServer.get_bus_volume_db(musicBusIndex)
	
	$MarginSettingsContainer/SettingsContainer/SFXControlContainer/SFXVolumeBar.value = 10 - (-1 * sfxVolume / 6)
	$MarginSettingsContainer/SettingsContainer/MusicControlContainer/MusicVolumeBar.value = 10 - (-1 * musicVolume / 6)

func _on_play_button_pressed():
		get_tree().change_scene_to_file(loadedLvlName)

func _on_settings_button_pressed():
	$MarginButtonsContainer.visible = false
	$MarginSettingsContainer.visible = true
	$ButtonClickPlayer.play()
	
func _on_exit_button_pressed():
	get_tree().quit()
	$ButtonClickPlayer.play()

func _on_return_button_pressed():
	$MarginSettingsContainer.visible = false
	$MarginButtonsContainer.visible = true
	$ButtonClickPlayer.play()

func _on_reset_button_pressed():
	$MarginSettingsContainer.visible = false
	$MarginResetContainer.visible = true
	$ButtonClickPlayer.play()

func _on_reset_cancel_button_pressed():
	$MarginSettingsContainer.visible = true
	$MarginResetContainer.visible = false
	$ButtonClickPlayer.play()

func _on_reset_confirm_button_pressed():
	DirAccess.remove_absolute("user://savegame.save")
	$MarginSettingsContainer.visible = true
	$MarginResetContainer.visible = false
	$ButtonClickPlayer.play()

func _on_lower_sfx_button_pressed():
	$ButtonClickPlayer.play()
	var busIndex = AudioServer.get_bus_index("SFX")
	var busVolume = AudioServer.get_bus_volume_db(busIndex)
	
	if busVolume > -60:
		$MarginSettingsContainer/SettingsContainer/SFXControlContainer/SFXVolumeBar.value -= 1
		AudioServer.set_bus_volume_db(busIndex, busVolume - 6)
		
		var configFile = ConfigFile.new()
		configFile.set_value("Audio", "sfxVol", busVolume - 6)
		configFile.set_value("Audio", "musicVol", AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
		configFile.save("user://settings.cfg")

func _on_higher_sfx_button_pressed():
	$ButtonClickPlayer.play()
	var busIndex = AudioServer.get_bus_index("SFX")
	var busVolume = AudioServer.get_bus_volume_db(busIndex)
	
	if busVolume < 0:
		$MarginSettingsContainer/SettingsContainer/SFXControlContainer/SFXVolumeBar.value += 1
		AudioServer.set_bus_volume_db(busIndex, busVolume + 6)
		
		var configFile = ConfigFile.new()
		configFile.set_value("Audio", "sfxVol", busVolume + 6)
		configFile.set_value("Audio", "musicVol", AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
		configFile.save("user://settings.cfg")

func _on_lower_music_button_pressed():
	$ButtonClickPlayer.play()
	var busIndex = AudioServer.get_bus_index("Music")
	var busVolume = AudioServer.get_bus_volume_db(busIndex)
	
	if busVolume > -60:
		$MarginSettingsContainer/SettingsContainer/MusicControlContainer/MusicVolumeBar.value -= 1
		AudioServer.set_bus_volume_db(busIndex, busVolume - 6)
		
		var configFile = ConfigFile.new()
		configFile.set_value("Audio", "sfxVol", AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))
		configFile.set_value("Audio", "musicVol", busVolume - 6)
		configFile.save("user://settings.cfg")


func _on_higher_music_button_pressed():
	$ButtonClickPlayer.play()
	var busIndex = AudioServer.get_bus_index("Music")
	var busVolume = AudioServer.get_bus_volume_db(busIndex)
	
	if busVolume < 0:
		$MarginSettingsContainer/SettingsContainer/MusicControlContainer/MusicVolumeBar.value += 1
		AudioServer.set_bus_volume_db(busIndex, busVolume + 6)
		
		var configFile = ConfigFile.new()
		configFile.set_value("Audio", "sfxVol", AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))
		configFile.set_value("Audio", "musicVol", busVolume + 6)
		configFile.save("user://settings.cfg")
