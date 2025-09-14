class_name OilSliderEffect
extends NullEffect

export (PackedScene) var structure_scene
export (float) var chance
export (float) var effect_timer
export (float) var speed_modifier
export (float) var damage_multiplier

static func get_id() -> String:
	return "weapon_oil_slider_effect"
	
func get_args(player_index: int) -> Array:
	return [
		str(round(chance * 100.0)),
		str(round(speed_modifier * 100.0 - 100.0)),
		str(damage_multiplier),
		str(effect_timer)
		]

# TODO: learn what serialize / deserialize does and use it
