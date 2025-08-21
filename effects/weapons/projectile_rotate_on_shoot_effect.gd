class_name ProjectileRotateOnShootEffect
extends NullEffect

export (Resource) var original_weapon_stats
export (float) var damage_multiplier
export (Array, AudioStream) var shooting_sounds
export (PackedScene) var rotating_projectile_scene

static func get_id() -> String:
	return "weapon_projectile_rotate_on_shoot"
	
func get_args(player_index: int) -> Array:
	var current_stats = WeaponService.init_ranged_stats(original_weapon_stats, player_index, true)
	#TODO: bugged scaling like mega buster
	var scaling_text = WeaponService.get_scaling_stats_icon_text(original_weapon_stats.scaling_stats)
	return [str(int(ceil(current_stats.damage / damage_multiplier))), scaling_text]

