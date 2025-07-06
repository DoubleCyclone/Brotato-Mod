class_name ProjectileRotateOnShootEffect
extends NullEffect

export (Resource) var weapon_stats
export (bool) var auto_target_enemy = false


static func get_id() -> String:
	return "weapon_projectile_rotate_on_shoot"
