class_name SidewaysProjectilesOnShoot
extends NullEffect

export (float) var damage_multiplier
export (float, 0.0, 1.0, 0.01) var chance: = 1.0
export (PackedScene) var side_projectile_scene

static func get_id() -> String:
	return "weapon_sideways_projectiles_on_shoot"
	
func get_args(player_index: int) -> Array:
	return [str(chance * 100), str(1/damage_multiplier)]

