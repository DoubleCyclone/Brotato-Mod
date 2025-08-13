class_name MegaBusterChargedShotEffect
extends Effect

export (Resource) var charged_projectile_stats

static func get_id() -> String:
	return "mega_buster_charged_shot_effect"
	
func get_args(_player_index: int) -> Array:
	var charged_stats = WeaponService.init_ranged_stats(charged_projectile_stats, _player_index, true)
	var scaling_text = WeaponService.get_scaling_stats_icon_text(charged_stats.scaling_stats)
	return [str(value), str(charged_projectile_stats.piercing), str(charged_stats.damage), str(scaling_text)]
