extends Node


func _ready():
	if not FileAccess.file_exists("user://savegame.save"):
		return
	else:
		var restoredSave = FileAccess.open("user://savegame.save", FileAccess.READ)
		var jsonData = restoredSave.get_line()
		var json = JSON.new()
		var parsedJson = json.parse(jsonData)
		if not parsedJson == OK:
			print("JSON PARSE ERROR: ", json.get_error_message())
			
		var data = json.get_data()
		
		var playerObj = get_node("PlayerRoot/Player")
		
		playerObj.coins = int(data['coins'])
		playerObj.healthPotions = int(data['healthPotions'])
		playerObj.speedPotions = int(data['speedPotions'])
		playerObj.cooldownPotions = int(data['cooldownPotions'])
		playerObj.skillPoints = int(data['skillPoints'])
		playerObj.fireLvl = int(data['fireLvl'])
		playerObj.waterLvl = int(data['waterLvl'])
		playerObj.lightningLvl = int(data['lightningLvl'])
		playerObj.earthLvl = int(data['earthLvl'])
		playerObj.artifacts = int(data['artifacts'])

		get_node("PlayerRoot/HUD").restore_from_save()

	var config = ConfigFile.new()
	var err = config.load("user://settings.cfg")
	
	var sfxBusIndex = AudioServer.get_bus_index("SFX")
	var musicBusIndex = AudioServer.get_bus_index("Music")
	
	if err != OK:
		AudioServer.set_bus_volume_db(sfxBusIndex, -30)
		AudioServer.set_bus_volume_db(musicBusIndex, -30)
	else:
		AudioServer.set_bus_volume_db(sfxBusIndex, config.get_value("Audio", "sfxVol"))
		AudioServer.set_bus_volume_db(musicBusIndex, config.get_value("Audio", "musicVol"))
