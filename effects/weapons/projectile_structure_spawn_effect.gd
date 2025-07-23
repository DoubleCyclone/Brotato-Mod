class_name ProjectileStructureSpawnEffect
extends NullEffect

export (PackedScene) var structure_scene
export (float) var chance

static func get_id() -> String:
	return "weapon_structure_spawn"
