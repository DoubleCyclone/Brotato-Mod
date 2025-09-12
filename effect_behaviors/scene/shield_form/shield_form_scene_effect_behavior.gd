class_name ShieldFormSceneEffectBehavior
extends SceneEffectBehavior


func _ready() -> void :
	if should_check():
		print("checking")


func should_check() -> bool:
	if RunData.existing_weapon_has_effect("shield_form"):
		return true
	for player_index in RunData.get_player_count():
		if RunData.get_player_effect("shield_form", player_index).size()  > 0:
			return true
	return false
