class_name SidewaysProjectilesOnShoot
extends NullEffect

export (Resource) var original_weapon_stats
export (float) var damage_multiplier
export (float, 0.0, 1.0, 0.01) var chance: = 1.0
export (PackedScene) var side_projectile_scene

static func get_id() -> String:
	return "weapon_sideways_projectiles_on_shoot"
	
func get_args(player_index: int) -> Array:
	var current_stats = WeaponService.init_ranged_stats(original_weapon_stats, player_index, true)
#	var scaling_text = WeaponService.get_scaling_stats_icon_text(current_stats.scaling_stats)
	return [str(chance * 100), str(1/damage_multiplier), str(ceil(current_stats.damage / damage_multiplier))]


