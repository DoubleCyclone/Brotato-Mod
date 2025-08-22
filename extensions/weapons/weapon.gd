extends "res://weapons/weapon.gd"

func init_stats(at_wave_begin: bool = true) -> void :
	# TODO EXPERIMENTAL : WORKS BUT I DON'T WANT TO EXTEND
	if !at_wave_begin and RunData.get_player_effect("weapon_energy_bar", player_index) != 0:
		return
	# EXPERIMENTAL END
	var args: = WeaponServiceInitStatsArgs.new()
	args.sets = weapon_sets
	args.effects = effects
	if stats is RangedWeaponStats:
		current_stats = WeaponService.init_ranged_stats(stats, player_index, false, args)
		_stats_every_x_shots = WeaponService.init_stats_every_x_projectiles(stats, player_index, args)
		for x_shot_stats in _stats_every_x_shots.values():
			x_shot_stats.burning_data.from = self
	else:
		current_stats = WeaponService.init_melee_stats(stats, player_index, args)

	_hitbox.projectiles_on_hit = []

	var on_hit_args: = WeaponServiceInitStatsArgs.new()
	for effect in effects:
		if effect is ProjectilesOnHitEffect:
			var weapon_stats = WeaponService.init_ranged_stats(effect.weapon_stats, player_index, true, on_hit_args)
			_hitbox.projectiles_on_hit = [effect.value, weapon_stats, effect.auto_target_enemy]

	current_stats.burning_data.from = self

	var hitbox_args: = Hitbox.HitboxArgs.new().set_from_weapon_stats(current_stats)

	_hitbox.effect_scale = current_stats.effect_scale
	_hitbox.set_damage(current_stats.damage, hitbox_args)
	_hitbox.speed_percent_modifier = current_stats.speed_percent_modifier
	_hitbox.effects = effects
	_hitbox.from = self

	if at_wave_begin:
		_current_cooldown = get_next_cooldown(at_wave_begin)

	reset_cooldown()
	_range_shape.shape.radius = current_stats.max_range + DETECTION_RANGE
