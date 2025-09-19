class_name ProjectileRotateOnShootEffect
extends NullEffect

export (float) var damage_multiplier
export (int) var extra_piercing
export (Array, AudioStream) var shooting_sounds
export (PackedScene) var rotating_projectile_scene
export (int) var rotating_speed
export(float, 0, 1, 0.05) var piercing_dmg_reduction

static func get_id() -> String:
	return "projectile_projectile_rotate_on_shoot"
	
func get_args(player_index: int) -> Array:
	# TODO : cursed variants don't show the stats correctly when derived from original stats
	return [str(1/damage_multiplier), "+" + str(extra_piercing)]

