class_name OilSliderEffect
extends NullEffect

export (PackedScene) var structure_scene
export (float) var chance
export (float) var effect_timer
export (Resource) var stats
export (float) var speed_modifier

static func get_id() -> String:
	return "weapon_oil_slider_effect"
