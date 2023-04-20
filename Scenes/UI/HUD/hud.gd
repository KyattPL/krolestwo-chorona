extends CanvasLayer

var fireSpellWaitTime
var waterSpellWaitTime
var lightningSpellWaitTime
var earthSpellWaitTime

enum SPELL { NONE, FIRE, WATER, LIGHTNING, EARTH }

func _ready():
	$HUD/Stats/PlayerHPBar.value = 100

func _on_player_health_lost(oldVal, newVal):
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

	if newVal == SPELL.FIRE:
		$HUD/Stats/FireSpellBox/FireSpellIcon.modulate = Color.hex(0xffd500)
	elif newVal == SPELL.WATER:
		$HUD/Stats/WaterSpellBox/WaterSpellIcon.modulate = Color.hex(0xffd500)
	elif newVal == SPELL.LIGHTNING:
		$HUD/Stats/LightningSpellBox/LightningSpellIcon.modulate = Color.hex(0xffd500)
	elif newVal == SPELL.EARTH:
		$HUD/Stats/EarthSpellBox/EarthSpellIcon.modulate = Color.hex(0xffd500)
