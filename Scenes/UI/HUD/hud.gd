extends CanvasLayer

var fireSpellWaitTime
var waterSpellWaitTime
var lightningSpellWaitTime
var earthSpellWaitTime

enum SPELL { NONE, FIRE, WATER, LIGHTNING, EARTH }

func _ready():
	$HUD/Stats/PlayerHPBar.value = 100

func _on_player_health_changed(oldVal, newVal):
	$HUD/Stats/PlayerHPBar.value = newVal

func _on_player_coins_changed(oldVal, newVal):
	$HUD/Stats/CoinsText.text = str(newVal)

func _on_player_root_fire_on_cd(waitTime):
	$HUD/Stats/FireSpellBox/FireSpellIcon.modulate = Color.from_hsv(1, 0, 0.25)
	$HUD/Stats/FireSpellBox/FireSpellCD.visible = true
	$HUD/Stats/FireSpellBox/FireSpellCD.text = "[center]" + str(waitTime) + "[/center]"
	$HUD/Stats/FireSpellBox/FireSpellTimer.start()
	fireSpellWaitTime = waitTime
	
func _on_player_root_water_on_cd(waitTime):
	$HUD/Stats/WaterSpellBox/WaterSpellIcon.modulate = Color.from_hsv(1, 0, 0.25)
	$HUD/Stats/WaterSpellBox/WaterSpellCD.visible = true
	$HUD/Stats/WaterSpellBox/WaterSpellCD.text = "[center]" + str(waitTime) + "[/center]"
	$HUD/Stats/WaterSpellBox/WaterSpellTimer.start()
	waterSpellWaitTime = waitTime
	
func _on_player_root_lightning_on_cd(waitTime):
	$HUD/Stats/LightningSpellBox/LightningSpellIcon.modulate = Color.from_hsv(1, 0, 0.25)
	$HUD/Stats/LightningSpellBox/LightningSpellCD.visible = true
	$HUD/Stats/LightningSpellBox/LightningSpellCD.text = "[center]" + str(waitTime) + "[/center]"
	$HUD/Stats/LightningSpellBox/LightningSpellTimer.start()
	lightningSpellWaitTime = waitTime
	
func _on_player_root_earth_on_cd(waitTime):
	$HUD/Stats/EarthSpellBox/EarthSpellIcon.modulate = Color.from_hsv(1, 0, 0.25)
	$HUD/Stats/EarthSpellBox/EarthSpellCD.visible = true
	$HUD/Stats/EarthSpellBox/EarthSpellCD.text = "[center]" + str(waitTime) + "[/center]"
	$HUD/Stats/EarthSpellBox/EarthSpellTimer.start()
	earthSpellWaitTime = waitTime
	
func _on_fire_spell_timer_timeout():
	fireSpellWaitTime -= 1
	if fireSpellWaitTime == 0:
		$HUD/Stats/FireSpellBox/FireSpellIcon.modulate = Color.from_hsv(0,0,1)
		$HUD/Stats/FireSpellBox/FireSpellCD.visible = false
		$HUD/Stats/FireSpellBox/FireSpellTimer.stop()
	else:
		$HUD/Stats/FireSpellBox/FireSpellCD.text = "[center]" + str(fireSpellWaitTime) + "[/center]"


func _on_water_spell_timer_timeout():
	waterSpellWaitTime -= 1
	if waterSpellWaitTime == 0:
		$HUD/Stats/WaterSpellBox/WaterSpellIcon.modulate = Color.from_hsv(0,0,1)
		$HUD/Stats/WaterSpellBox/WaterSpellCD.visible = false
		$HUD/Stats/WaterSpellBox/WaterSpellTimer.stop()
	else:
		$HUD/Stats/WaterSpellBox/WaterSpellCD.text = "[center]" + str(waterSpellWaitTime) + "[/center]"


func _on_lightning_spell_timer_timeout():
	lightningSpellWaitTime -= 1
	if lightningSpellWaitTime == 0:
		$HUD/Stats/LightningSpellBox/LightningSpellIcon.modulate = Color.from_hsv(0,0,1)
		$HUD/Stats/LightningSpellBox/LightningSpellCD.visible = false
		$HUD/Stats/LightningSpellBox/LightningSpellTimer.stop()
	else:
		$HUD/Stats/LightningSpellBox/LightningSpellCD.text = "[center]" + str(lightningSpellWaitTime) + "[/center]"


func _on_earth_spell_timer_timeout():
	earthSpellWaitTime -= 1
	if earthSpellWaitTime == 0:
		$HUD/Stats/EarthSpellBox/EarthSpellIcon.modulate = Color.from_hsv(0,0,1)
		$HUD/Stats/EarthSpellBox/EarthSpellCD.visible = false
		$HUD/Stats/EarthSpellBox/EarthSpellTimer.stop()
	else:
		$HUD/Stats/EarthSpellBox/EarthSpellCD.text = "[center]" + str(earthSpellWaitTime) + "[/center]"

func _on_player_spell_selected(oldVal, newVal):
	if oldVal == SPELL.FIRE:
		$HUD/Stats/FireSpellBox/FireSpellIcon.modulate = Color.from_hsv(0,0,1)
	elif oldVal == SPELL.WATER:
		$HUD/Stats/WaterSpellBox/WaterSpellIcon.modulate = Color.from_hsv(0,0,1)
	elif oldVal == SPELL.LIGHTNING:
		$HUD/Stats/LightningSpellBox/LightningSpellIcon.modulate = Color.from_hsv(0,0,1)
	elif oldVal == SPELL.EARTH:
		$HUD/Stats/EarthSpellBox/EarthSpellIcon.modulate = Color.from_hsv(0,0,1)

	if oldVal != newVal:
		if newVal == SPELL.FIRE:
			$HUD/Stats/FireSpellBox/FireSpellIcon.modulate = Color.from_hsv(0.14, 1, 1)
		elif newVal == SPELL.WATER:
			$HUD/Stats/WaterSpellBox/WaterSpellIcon.modulate = Color.from_hsv(0.14, 1, 1)
		elif newVal == SPELL.LIGHTNING:
			$HUD/Stats/LightningSpellBox/LightningSpellIcon.modulate = Color.from_hsv(0.14, 1, 1)
		elif newVal == SPELL.EARTH:
			$HUD/Stats/EarthSpellBox/EarthSpellIcon.modulate = Color.from_hsv(0.14, 1, 1)

func _on_player_used_potion(potionType):
	match potionType:
		0:
			var count = $HUD/Items/HealthPotionBox/HealthPotionTextBox/HealthPotionCount.text
			print(count)
			$HUD/Items/HealthPotionBox/HealthPotionTextBox/HealthPotionCount.text = str(int(count) - 1)
		1:
			var count = $HUD/Items/SpeedPotionBox/SpeedPotionTextBox/SpeedPotionCount.text
			$HUD/Items/SpeedPotionBox/SpeedPotionTextBox/SpeedPotionCount.text = str(int(count) - 1)
		2:
			var count = $HUD/Items/CooldownPotionBox/CooldownPotionTextBox/CooldownPotionCount.text
			$HUD/Items/CooldownPotionBox/CooldownPotionTextBox/CooldownPotionCount.text = str(int(count) - 1)
			
			fireSpellWaitTime = 0
			$HUD/Stats/FireSpellBox/FireSpellIcon.modulate = Color.from_hsv(0,0,1)
			$HUD/Stats/FireSpellBox/FireSpellCD.visible = false
			$HUD/Stats/FireSpellBox/FireSpellTimer.stop()
			get_node("../FireSpellCD").stop()
			get_node("../FireSpellCD").emit_signal("timeout")
			
			waterSpellWaitTime = 0
			$HUD/Stats/WaterSpellBox/WaterSpellIcon.modulate = Color.from_hsv(0,0,1)
			$HUD/Stats/WaterSpellBox/WaterSpellCD.visible = false
			$HUD/Stats/WaterSpellBox/WaterSpellTimer.stop()
			get_node("../WaterSpellCD").stop()
			get_node("../WaterSpellCD").emit_signal("timeout")
			
			lightningSpellWaitTime = 0
			$HUD/Stats/LightningSpellBox/LightningSpellIcon.modulate = Color.from_hsv(0,0,1)
			$HUD/Stats/LightningSpellBox/LightningSpellCD.visible = false
			$HUD/Stats/LightningSpellBox/LightningSpellTimer.stop()
			get_node("../LightningSpellCD").stop()
			get_node("../LightningSpellCD").emit_signal("timeout")
			
			earthSpellWaitTime = 0
			$HUD/Stats/EarthSpellBox/EarthSpellIcon.modulate = Color.from_hsv(0,0,1)
			$HUD/Stats/EarthSpellBox/EarthSpellCD.visible = false
			$HUD/Stats/EarthSpellBox/EarthSpellTimer.stop()
			get_node("../EarthSpellCD").stop()
			get_node("../EarthSpellCD").emit_signal("timeout")

func _on_skill_tree_open_button_pressed():
	get_tree().paused = true
	var playerNode = get_node("../Player")
	$HUD/SkillTree/SkillTreeBox/SkillPointsBox/SkillPointsText.text = '[center]Points: ' + str(playerNode.skillPoints) + '[/center]'
	$HUD/Stats.visible = false
	$HUD/Items.visible = false
	$HUD/SkillTree/SkillTreeOpenBox.visible = false
	$HUD/SkillTree/SkillTreeBox.visible = true

func _on_skill_tree_close_button_pressed():
	$HUD/Stats.visible = true
	$HUD/Items.visible = true
	$HUD/SkillTree/SkillTreeOpenBox.visible = true
	$HUD/SkillTree/SkillTreeBox.visible = false
	get_tree().paused = false

func _on_better_fire_button_pressed():
	var playerNode = get_node("../Player")
	if playerNode.fireLvl == 1 and playerNode.skillPoints > 0:
		$HUD/SkillTree/SkillTreeBox/SkillTreeGridBox/SkillTreeGrid/FireSkillColumn/BetterFireBox.modulate = Color.from_hsv(0,0,1)
		playerNode.fireLvl = 2
		playerNode.skillPoints -= 1
		$HUD/SkillTree/SkillTreeBox/SkillPointsBox/SkillPointsText.text = '[center]Points: ' + str(playerNode.skillPoints) + '[/center]'
		get_node("../FireSpellCD").wait_time -= 3

func _on_best_fire_button_pressed():
	var playerNode = get_node("../Player")
	if playerNode.fireLvl == 2 and playerNode.skillPoints > 0:
		$HUD/SkillTree/SkillTreeBox/SkillTreeGridBox/SkillTreeGrid/FireSkillColumn/BestFireBox.modulate = Color.from_hsv(0,0,1)
		playerNode.fireLvl = 3
		playerNode.skillPoints -= 1
		$HUD/SkillTree/SkillTreeBox/SkillPointsBox/SkillPointsText.text = '[center]Points: ' + str(playerNode.skillPoints) + '[/center]'

func _on_better_water_button_pressed():
	var playerNode = get_node("../Player")
	if playerNode.waterLvl == 1 and playerNode.skillPoints > 0:
		$HUD/SkillTree/SkillTreeBox/SkillTreeGridBox/SkillTreeGrid/WaterSkillColumn/BetterWaterBox.modulate = Color.from_hsv(0,0,1)
		playerNode.waterLvl = 2
		playerNode.skillPoints -= 1
		$HUD/SkillTree/SkillTreeBox/SkillPointsBox/SkillPointsText.text = '[center]Points: ' + str(playerNode.skillPoints) + '[/center]'
		get_node("../WaterSpellCD").wait_time -= 2

func _on_best_water_button_pressed():
	var playerNode = get_node("../Player")
	if playerNode.waterLvl == 2 and playerNode.skillPoints > 0:
		$HUD/SkillTree/SkillTreeBox/SkillTreeGridBox/SkillTreeGrid/WaterSkillColumn/BestWaterBox.modulate = Color.from_hsv(0,0,1)
		playerNode.waterLvl = 3
		playerNode.skillPoints -= 1
		$HUD/SkillTree/SkillTreeBox/SkillPointsBox/SkillPointsText.text = '[center]Points: ' + str(playerNode.skillPoints) + '[/center]'


func _on_better_lightning_button_pressed():
	var playerNode = get_node("../Player")
	if playerNode.lightningLvl == 1 and playerNode.skillPoints > 0:
		$HUD/SkillTree/SkillTreeBox/SkillTreeGridBox/SkillTreeGrid/LightningSkillColumn/BetterLightningBox.modulate = Color.from_hsv(0,0,1)
		playerNode.lightningLvl = 2
		playerNode.skillPoints -= 1
		$HUD/SkillTree/SkillTreeBox/SkillPointsBox/SkillPointsText.text = '[center]Points: ' + str(playerNode.skillPoints) + '[/center]'
		get_node("../LightningSpellCD").wait_time -= 3

func _on_best_lightning_button_pressed():
	var playerNode = get_node("../Player")
	if playerNode.lightningLvl == 2 and playerNode.skillPoints > 0:
		$HUD/SkillTree/SkillTreeBox/SkillTreeGridBox/SkillTreeGrid/LightningSkillColumn/BestLightningBox.modulate = Color.from_hsv(0,0,1)
		playerNode.lightningLvl = 3
		playerNode.skillPoints -= 1
		$HUD/SkillTree/SkillTreeBox/SkillPointsBox/SkillPointsText.text = '[center]Points: ' + str(playerNode.skillPoints) + '[/center]'


func _on_better_earth_button_pressed():
	var playerNode = get_node("../Player")
	if playerNode.earthLvl == 1 and playerNode.skillPoints > 0:
		$HUD/SkillTree/SkillTreeBox/SkillTreeGridBox/SkillTreeGrid/EarthSkillColumn/BetterEarthBox.modulate = Color.from_hsv(0,0,1)
		playerNode.earthLvl = 2
		playerNode.skillPoints -= 1
		$HUD/SkillTree/SkillTreeBox/SkillPointsBox/SkillPointsText.text = '[center]Points: ' + str(playerNode.skillPoints) + '[/center]'
		get_node("../EarthSpellCD").wait_time -= 4

func _on_best_earth_button_pressed():
	var playerNode = get_node("../Player")
	if playerNode.earthLvl == 2 and playerNode.skillPoints > 0:
		$HUD/SkillTree/SkillTreeBox/SkillTreeGridBox/SkillTreeGrid/EarthSkillColumn/BestEarthBox.modulate = Color.from_hsv(0,0,1)
		playerNode.earthLvl = 3
		playerNode.skillPoints -= 1
		$HUD/SkillTree/SkillTreeBox/SkillPointsBox/SkillPointsText.text = '[center]Points: ' + str(playerNode.skillPoints) + '[/center]'
