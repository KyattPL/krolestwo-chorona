extends CanvasLayer

@export var joystick_sens = 700

var dialogKey: String
var dialogsArray: Array
var currentIndex = 0

func load_json_data():
	if FileAccess.file_exists("res://Assets/DIALOGS/dialogs.json"):
		var jsonFile = FileAccess.open("res://Assets/DIALOGS/dialogs.json", FileAccess.READ)
		var fileData = jsonFile.get_as_text()
		var json = JSON.new()
		var parsedJson = json.parse(fileData)
		if not parsedJson == OK:
			print("JSON PARSE ERROR: ", json.get_error_message())
			
		dialogsArray = json.get_data()[dialogKey]
		$MarginContainer/MarginContainer/RichTextLabel.text = dialogsArray[0]

func joystick_aim(delta):
	var direction: Vector2
	direction.x = Input.get_action_strength("aim_right") - Input.get_action_strength("aim_left")
	direction.y = Input.get_action_strength("aim_down") - Input.get_action_strength("aim_up")
	
	direction = direction.normalized()
	#if abs(direction.x) == 1 and abs(direction.y) == 1:
	#	direction = direction.normalized()

	var movement = joystick_sens * direction * delta
	if (movement):
		get_viewport().warp_mouse(get_viewport().get_mouse_position() + movement)

func next_line():
	currentIndex += 1
	if currentIndex < dialogsArray.size():
		$MarginContainer/MarginContainer/RichTextLabel.text = dialogsArray[currentIndex]
	else:
		currentIndex = 0
		$MarginContainer/MarginContainer/RichTextLabel.text = dialogsArray[currentIndex]
		get_tree().paused = false
		get_node("../ActionTooltip").visible = true
		get_node("../../PlayerRoot/HUD").visible = true
		visible = false

func _on_button_pressed():
	$ButtonClickPlayer.play()
	next_line()
	
func _process(delta):
	joystick_aim(delta)
	if Input.is_action_just_pressed("confirm"):
			next_line()
