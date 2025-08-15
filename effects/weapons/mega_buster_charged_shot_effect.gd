class_name MegaBusterChargedShotEffect
extends Effect

export (Resource) var original_weapon_stats
export (PackedScene) var charged_projectile_scene
export (int) var extra_piercing
export (float) var damage_multiplier
export (Array, AudioStreamSample) var charged_shot_sounds
var count = 0
var charged_scaling_stats = []


static func get_id() -> String:
	return "mega_buster_charged_shot_effect"
	
func get_args(_player_index: int) -> Array:
	var original_stats = WeaponService.init_ranged_stats(original_weapon_stats, _player_index, true)
	return [str(value), str(original_stats.piercing + extra_piercing), str(damage_multiplier)]
