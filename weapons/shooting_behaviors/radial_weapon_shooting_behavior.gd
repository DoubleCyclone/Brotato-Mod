class_name RadialWeaponShootingBehavior
extends WeaponShootingBehavior

#signal projectile_shot(projectile)


func shoot(_distance: float) -> void :
	SoundManager.play(Utils.get_rand_element(_parent.current_stats.shooting_sounds), _parent.current_stats.sound_db_mod, 0.2)

	var initial_position: Vector2 = _parent.sprite.position

	_parent.set_shooting(true)
	
	var exploding_effect = null
	for effect in _parent.effects :
		if effect is ExplodingEffect:
			exploding_effect = effect
	
	var args: = WeaponServiceExplodeArgs.new()
	args.pos = global_position
	args.damage = _parent.current_stats.damage
	args.accuracy = _parent.current_stats.accuracy
	args.crit_chance = _parent.current_stats.crit_chance
	args.crit_damage = _parent.current_stats.crit_damage
	args.burning_data = _parent.current_stats.burning_data
	args.scaling_stats = _parent.current_stats.scaling_stats
	args.from_player_index = _parent._get_player_index()
#	args.damage_tracking_key = _parent.current_stats.explosion_effect.tracking_key
	args.from = self

	var attack_id: = _get_next_attack_id()
	for i in _parent.current_stats.nb_projectiles:
		if exploding_effect != null :
			var proj_rotation = rand_range(_parent.rotation - _parent.current_stats.projectile_spread, _parent.rotation + _parent.current_stats.projectile_spread)
			var knockback_direction: = Vector2(cos(proj_rotation), sin(proj_rotation))
			WeaponService.explode(exploding_effect, args)
#			var projectile = shoot_projectile(proj_rotation, knockback_direction)
#			projectile._hitbox.player_attack_id = attack_id

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


#func shoot_projectile(rotation: float = _parent.rotation, knockback: Vector2 = Vector2.ZERO) -> Node:
#	var args: = WeaponServiceSpawnProjectileArgs.new()
#	args.knockback_direction = knockback
#	args.effects = _parent.effects
#	args.from_player_index = _parent.player_index
#
#	var projectile = WeaponService.spawn_projectile(
#		_parent.muzzle.global_position, 
#		_parent.current_stats, 
#		rotation, 
#		_parent, 
#		args
#	)
#
#	emit_signal("projectile_shot", projectile)
#	return projectile
