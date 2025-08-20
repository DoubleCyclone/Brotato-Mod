class_name RollingCutterBoomerangEffect
extends NullEffect

export (Resource) var weapon_stats

static func get_id() -> String:
	return "weapon_boomerang"

func get_args(_player_index: int) -> Array:
	var current_stats = WeaponService.init_ranged_stats(weapon_stats, _player_index, true)
	return [str(round(current_stats.projectile_speed)), str(round(current_stats.max_range / 4)), str(round((current_stats.max_range / 4) * 0.75))]
