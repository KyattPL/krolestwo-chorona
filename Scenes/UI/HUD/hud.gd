extends CanvasLayer

func _ready():
	$HUD/Stats/PlayerHPBar.value = 100

func _on_player_health_lost(oldVal, newVal):
	$HUD/Stats/PlayerHPBar.value = newVal

func _on_player_coins_changed(oldVal, newVal):
	$HUD/Stats/CoinsText.text = str(newVal)
