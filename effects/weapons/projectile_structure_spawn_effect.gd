class_name ProjectileStructureSpawnEffect
extends NullEffect

export (PackedScene) var structure_scene
export (float) var chance
export (float) var effect_timer
export (Resource) var stats

static func get_id() -> String:
	return "weapon_structure_spawn"
