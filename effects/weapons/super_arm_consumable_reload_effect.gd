class_name SuperArmConsumableReloadEffect
extends NullEffect

export (float, 0.0, 1.0, 0.01) var consumable_drop_chance: = 1.0

static func get_id() -> String:
	return "weapon_super_arm_consumable_reload"
	
func get_args(player_index: int) -> Array:
	return [str(consumable_drop_chance * 100)]


