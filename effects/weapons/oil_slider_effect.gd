class_name OilSliderEffect
extends NullEffect

export (PackedScene) var structure_scene
export (float) var chance
export (float) var effect_timer
export (Resource) var stats
export (float) var speed_modifier
export (float) var damage_multiplier

static func get_id() -> String:
	return "weapon_oil_slider_effect"
	
func get_args(_player_index: int) -> Array:
	var scaling_text = WeaponService.get_scaling_stats_icon_text(stats.scaling_stats)
	var scaled_damage = WeaponService.apply_scaling_stats_to_damage(stats.damage, stats.scaling_stats, _player_index)
	return [str(round(chance * 100.0)), str(round(speed_modifier * 100.0 - 100.0)), str(scaled_damage), scaling_text, str(effect_timer)]

# TODO: learn what serialize / deserialize does and use it
# TODO: maybe add base damage values to the descriptions of the weapons
# TODO: fix description
