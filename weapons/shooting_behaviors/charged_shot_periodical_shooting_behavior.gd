class_name ChargedShotPediodicalShootingBehavior
extends WeaponShootingBehavior

signal projectile_shot(projectile)

var charged_initialized = false

func shoot(_distance: float) -> void :	
	var charging_effect
	for effect in _parent.effects:
		if effect.key == "charged_shot_periodical":
			charging_effect = effect
			
	# TODO might be better like fire storm
	if charging_effect:	
		if _parent._nb_shots_taken % charging_effect.value == 0:
			_parent.current_stats.damage *= charging_effect.damage_multiplier
			_parent.current_stats.piercing += charging_effect.extra_piercing
			_parent.current_stats.shooting_sounds = charging_effect.charged_shot_sounds
			_parent.current_stats.projectile_scene = charging_effect.charged_projectile_scene
			if !charged_initialized:
				charged_initialized = !charged_initialized
		else:
			if charged_initialized and _parent._nb_shots_taken % charging_effect.value == 1:
				_parent.current_stats.damage /= charging_effect.damage_multiplier
				_parent.current_stats.piercing -= charging_effect.extra_piercing
				_parent.current_stats.shooting_sounds = _parent.stats.shooting_sounds
				_parent.current_stats.projectile_scene = _parent.stats.projectile_scene
			
	SoundManager.play(Utils.get_rand_element(_parent.current_stats.shooting_sounds), _parent.current_stats.sound_db_mod, 0.2)
		
	var initial_position: Vector2 = _parent.sprite.position

	_parent.set_shooting(true)

	var attack_id: = _get_next_attack_id()
	for i in _parent.current_stats.nb_projectiles:
		var proj_rotation = rand_range(_parent.rotation - _parent.current_stats.projectile_spread, _parent.rotation + _parent.current_stats.projectile_spread)
		var knockback_direction: = Vector2(cos(proj_rotation), sin(proj_rotation))
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
