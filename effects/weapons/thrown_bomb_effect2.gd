class_name ThrownBomb2Effect
extends NullEffect

export (Array,Resource) var effects
export (PackedScene) var structure_scene
export (float) var timer_cooldown

static func get_id() -> String:
	return "effect_hyper_bomb_spawn"
	
