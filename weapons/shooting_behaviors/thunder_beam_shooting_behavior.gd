extends "res://weapons/shooting_behaviors/ranged_weapon_shooting_behavior.gd"

func shoot(_distance: float) -> void :
	SoundManager.play(Utils.get_rand_element(_parent.current_stats.shooting_sounds), _parent.current_stats.sound_db_mod, 0.2)

	var initial_position: Vector2 = _parent.sprite.position

	_parent.set_shooting(true)

	var attack_id: = _get_next_attack_id()
	
	
	var defaultProjectileCount = _parent.current_stats.nb_projectiles
	var currentProjectileCount = 1;
	# random number to decide if additional projectiles will be fired
	var random = rand_range(0,1)
	if(random < 0.67):
		currentProjectileCount = 1
	else:
		currentProjectileCount = defaultProjectileCount
		
	for i in currentProjectileCount:
		var proj_rotation
		if(currentProjectileCount>1):
			proj_rotation = _parent.rotation + ((i-1) * _parent.current_stats.projectile_spread)
		else:
			proj_rotation = _parent.rotation
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
