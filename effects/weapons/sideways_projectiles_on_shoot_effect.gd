class_name SidewaysProjectilesOnShoot
extends NullEffect

export (Resource) var weapon_stats
export (float, 0.0, 1.0, 0.01) var chance: = 1.0

static func get_id() -> String:
	return "weapon_sideways_projectiles_on_shoot"
	
func get_args(player_index: int) -> Array:
	var current_stats = WeaponService.init_ranged_stats(weapon_stats, player_index, true)
	var scaling_text = WeaponService.get_scaling_stats_icon_text(weapon_stats.scaling_stats)
	return [str(chance * 100), str(current_stats.damage) ,scaling_text]


