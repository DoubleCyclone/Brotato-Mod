class_name SuperArmConsumableEffect
extends NullEffect

func apply(_player_index: int) -> void:
	var main = Utils.get_scene_node()
	var highest_cd_weapon_that_should_reload = null
	
	for weapon in main._players[_player_index].current_weapons:
		for effect in weapon.effects:
			if effect.key == "reload_when_pickup_super_arm_stone":
				if not weapon._is_shooting and (highest_cd_weapon_that_should_reload == null or weapon._current_cooldown > highest_cd_weapon_that_should_reload._current_cooldown):
					highest_cd_weapon_that_should_reload = weapon
					
	if highest_cd_weapon_that_should_reload:
		highest_cd_weapon_that_should_reload._current_cooldown = 0
	
