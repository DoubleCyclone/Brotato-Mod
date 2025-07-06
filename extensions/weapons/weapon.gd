extends "res://weapons/weapon.gd"

func shoot() -> void :
	_nb_shots_taken += 1
	var original_stats: RangedWeaponStats
	for projectile_count in _stats_every_x_shots:
		
		if _nb_shots_taken % projectile_count == 0:
			original_stats = current_stats
			current_stats = _stats_every_x_shots[projectile_count]

	for effect in effects:
		if effect.key == "reload_turrets_on_shoot":
			emit_signal("wanted_to_reset_turrets_cooldown")
		elif effect.key == "effect_projectile_rotate_on_shoot":			
			var spawn_projectile_args = WeaponServiceSpawnProjectileArgs.new()
			var from = _hitbox.from if is_instance_valid(_hitbox.from) else null
			var from_player_index = from.player_index if (from != null and "player_index" in from) else RunData.DUMMY_PLAYER_INDEX
			spawn_projectile_args.from_player_index = from_player_index
			var init_stats_args = WeaponServiceInitStatsArgs.new()
			init_stats_args.effects = self.effects
			var rotating_weapon_stats = WeaponService.init_ranged_stats(effect.weapon_stats, player_index, true, init_stats_args)
			print("args",spawn_projectile_args)
			print("scale",rotating_weapon_stats.scaling_stats[0][1])
			WeaponService.manage_special_spawn_projectile(
				self,
				rotating_weapon_stats,
				0,
				false,
				_parent,
				self,
				spawn_projectile_args)

	update_current_spread()
	update_knockback()

	if is_manual_aim():
		_shooting_behavior.shoot(current_stats.max_range)
	else:
		_shooting_behavior.shoot(_current_target[1])

	_current_cooldown = get_next_cooldown()

	if (is_big_reload_active() or current_stats.additional_cooldown_every_x_shots == - 1) and stats.custom_on_cooldown_sprite != null:
		update_sprite(stats.custom_on_cooldown_sprite)

	if original_stats:
		current_stats = original_stats

