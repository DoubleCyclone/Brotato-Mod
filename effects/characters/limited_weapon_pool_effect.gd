class_name LimitedWeaponPoolEffect
extends Effect

export (Array, Resource) var allowed_weapon_sets

static func get_id() -> String:
	return "limited_weapon_pool_effect"
	
func apply(player_index: int) -> void:
	var effects = RunData.get_player_effects(player_index)
	for weapon_set in allowed_weapon_sets:	
		effects["limited_weapon_pool"].append(weapon_set)

func unapply(player_index: int) -> void:
	var effects = RunData.get_player_effects(player_index)
	for weapon_set in allowed_weapon_sets:
		effects["limited_weapon_pool"].erase(weapon_set)
	
func get_args(_player_index: int) -> Array:
	var weapon_set_names = []
	for weapon_set in allowed_weapon_sets:
		weapon_set_names.append(tr(weapon_set.name.to_upper()))
	return [str(weapon_set_names)]
