class_name RotatingProjectileWeaponShootingBehavior
extends WeaponShootingBehavior

signal projectile_shot(projectile)
signal shield_forming_projectile_shot(projectile)

var rotation_initialized = false
var original_damage
var original_bounce
var original_piercing
var will_form_shield = false


func shoot(_distance: float) -> void :
	original_bounce = _parent.current_stats.bounce
	original_piercing = _parent.current_stats.piercing
	var rotating_effect
	for effect in _parent.effects:
		if effect.key == "projectile_rotate_on_shoot":
			rotating_effect = effect
		if effect.key == "shield_form":
			will_form_shield = true
	
	SoundManager.play(Utils.get_rand_element(_parent.current_stats.shooting_sounds), _parent.current_stats.sound_db_mod, 0.2)

	var initial_position: Vector2 = _parent.sprite.position

	_parent.set_shooting(true)

	var attack_id: = _get_next_attack_id()
	for i in _parent.current_stats.nb_projectiles:
		var proj_rotation = rand_range(_parent.rotation - _parent.current_stats.projectile_spread, _parent.rotation + _parent.current_stats.projectile_spread)
		var knockback_direction: = Vector2(cos(proj_rotation), sin(proj_rotation))
		if rotating_effect:
		# revert stats for original projectile
			if _parent.stats.projectile_scene:
				if rotation_initialized:
					_parent.current_stats.shooting_sounds = _parent.stats.shooting_sounds 
					_parent.current_stats.piercing_dmg_reduction = _parent.stats.piercing_dmg_reduction 
					_parent.current_stats.can_bounce = true
					_parent.current_stats.projectile_scene = _parent.stats.projectile_scene
					_parent.current_stats.bounce = original_bounce
				# shoot original projectile
				var projectile = shoot_projectile(proj_rotation, knockback_direction)
				projectile._hitbox.player_attack_id = attack_id
			# change stats for rotation
			original_damage = _parent.current_stats.damage
			original_bounce = _parent.current_stats.bounce
			original_piercing = _parent.current_stats.piercing
			_parent.current_stats.damage = ceil(_parent.current_stats.damage / rotating_effect.damage_multiplier)
			if rotating_effect.shooting_sounds.size() != 0:
				_parent.current_stats.shooting_sounds = rotating_effect.shooting_sounds
			_parent.current_stats.piercing += rotating_effect.extra_piercing 
			_parent.current_stats.piercing_dmg_reduction = 0
			_parent.current_stats.bounce = 0
			_parent.current_stats.projectile_scene = rotating_effect.rotating_projectile_scene
			# shoot rotating projectile
			var rotating_projectile = shoot_projectile(proj_rotation, knockback_direction)
			rotating_projectile.rotating_speed = rotating_effect.rotating_speed
			# emit shield forming projectile shot signal
			if will_form_shield:
				emit_signal("shield_forming_projectile_shot", rotating_projectile)	
			if !rotation_initialized:
				rotation_initialized = !rotation_initialized
			rotating_projectile._hitbox.player_attack_id = attack_id
			# return stats to original state
			_parent.current_stats.damage = original_damage
			_parent.current_stats.bounce = original_bounce
			_parent.current_stats.piercing = original_piercing
		else: 
			# Failsafe
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

	var projectile

	projectile = WeaponService.spawn_projectile(
		_parent.muzzle.global_position, 
		_parent.current_stats, 
		rotation, 
		_parent, 
		args
	)

	emit_signal("projectile_shot", projectile)
	return projectile

func _on_hitbox_disabled():
	queue_free()
