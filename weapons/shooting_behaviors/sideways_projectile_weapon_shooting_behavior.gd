class_name SidewaysProjectileWeaponShootingBehavior
extends WeaponShootingBehavior

signal projectile_shot(projectile)

var side_initialized = false
var original_damage

func shoot(_distance: float) -> void :
	var sideways_effect
	for effect in _parent.effects:
		if effect.key == "sideways_projectiles_on_shoot":
			sideways_effect = effect
	
	SoundManager.play(Utils.get_rand_element(_parent.current_stats.shooting_sounds), _parent.current_stats.sound_db_mod, 0.2)

	var initial_position: Vector2 = _parent.sprite.position

	_parent.set_shooting(true)

	var attack_id: = _get_next_attack_id()
	for i in _parent.current_stats.nb_projectiles:
		var proj_rotation = rand_range(_parent.rotation - _parent.current_stats.projectile_spread, _parent.rotation + _parent.current_stats.projectile_spread)
		var knockback_direction: = Vector2(cos(proj_rotation), sin(proj_rotation))
		if sideways_effect:
			# revert stats for original projectile
			if side_initialized:
				_parent.current_stats.projectile_scene = _parent.stats.projectile_scene
			var projectile = shoot_projectile(proj_rotation, knockback_direction)
			projectile._hitbox.player_attack_id = attack_id
			# change stats for side projectiles
			if Utils.get_chance_success(sideways_effect.chance):
				original_damage = _parent.current_stats.damage
				_parent.current_stats.damage = ceil(_parent.current_stats.damage / sideways_effect.damage_multiplier)
				_parent.current_stats.projectile_scene = sideways_effect.side_projectile_scene
				for j in range(2):
					var sideways_projectile = shoot_sideways_projectile(j, proj_rotation, knockback_direction)
					sideways_projectile._hitbox.player_attack_id = attack_id
				if !side_initialized:
					side_initialized = !side_initialized
				_parent.current_stats.damage = original_damage
		else: # Failsafe
			var projectile = shoot_projectile(proj_rotation, knockback_direction)
			projectile._hitbox.player_attack_id = attack_id
			
	_parent.tween.interpolate_property(
		_parent.sprite,
		"position",
		initial_position,
		Vector2(initial_position.x - _parent.current_stats.recoil, initial_position.y),
		_parent.current_stats.recoil_duration,
		Tween.TRANS_EXPO,
		Tween.EASE_OUT
	)

	_parent.tween.start()
	yield(_parent.tween, "tween_all_completed")

	_parent.tween.interpolate_property(
		_parent.sprite,
		"position",
		_parent.sprite.position,
		initial_position,
		_parent.current_stats.recoil_duration,
		Tween.TRANS_EXPO,
		Tween.EASE_OUT
	)

	_parent.tween.start()
	yield(_parent.tween, "tween_all_completed")

	_parent.set_shooting(false)


func shoot_projectile(rotation: float = _parent.rotation, knockback: Vector2 = Vector2.ZERO) -> Node:
	var args: = WeaponServiceSpawnProjectileArgs.new()
	args.knockback_direction = knockback
	args.effects = _parent.effects
	args.from_player_index = _parent.player_index

	var projectile = WeaponService.spawn_projectile(
		_parent.muzzle.global_position,
		_parent.current_stats,
		rotation,
		_parent,
		args
	)

	emit_signal("projectile_shot", projectile)
	return projectile
	
func shoot_sideways_projectile(proj_number, rotation: float = _parent.rotation, knockback: Vector2 = Vector2.ZERO) -> Node:
	var args: = WeaponServiceSpawnProjectileArgs.new()
	args.knockback_direction = knockback
	args.effects = _parent.effects
	args.from_player_index = _parent.player_index

	var projectile = WeaponService.spawn_projectile(
		_parent.muzzle.global_position,
		_parent.current_stats,
		_parent.rotation + pow(-1, proj_number) * (1.57),
		_parent,
		args
	)

	emit_signal("projectile_shot", projectile)
	return projectile
	
	
#func shoot_sideways_projectile(proj_number, sideways_effect, rotation: float = _parent.rotation, knockback: Vector2 = Vector2.ZERO) -> Node:
#	var args: = WeaponServiceSpawnProjectileArgs.new()
#	args.knockback_direction = knockback
#	args.effects = _parent.effects
#	args.from_player_index = _parent.player_index
#
#	var init_stats_args = WeaponServiceInitStatsArgs.new()
#	init_stats_args.effects = _parent.effects
#	var sideways_weapon_stats = WeaponService.init_ranged_stats(sideways_effect.weapon_stats, _parent.player_index, true, init_stats_args)
#
#	var projectile = WeaponService.spawn_projectile(
#		_parent.muzzle.global_position,
#		sideways_weapon_stats,
#		_parent.rotation + pow(-1, proj_number) * (1.57),
#		_parent,
#		args
#	)
#
#	emit_signal("projectile_shot", projectile)
#	return projectile
#
	

