class_name RadialWeaponShootingBehavior
extends WeaponShootingBehavior

signal projectile_shot(projectile)


func shoot(_distance: float) -> void :
	SoundManager.play(Utils.get_rand_element(_parent.current_stats.shooting_sounds), _parent.current_stats.sound_db_mod, 0.2)

#	var initial_position: Vector2 = _parent.sprite.position

	_parent.set_shooting(true)
	
	var exploding_effect = null
	for effect in _parent.effects :
		if effect.key == "radial_explosion":
			exploding_effect = effect
			exploding_effect.scale = _parent.current_stats.max_range / 100
	
	var args: = WeaponServiceExplodeArgs.new()
	args.pos = _parent.sprite.global_position
	args.damage = _parent.current_stats.damage
	args.accuracy = _parent.current_stats.accuracy
	args.crit_chance = _parent.current_stats.crit_chance
	args.crit_damage = _parent.current_stats.crit_damage
	args.burning_data = _parent.current_stats.burning_data
	args.scaling_stats = _parent.current_stats.scaling_stats
	args.from_player_index = _parent._get_player_index()
#	args.damage_tracking_key = _parent.tracking_text
	args.from = self

	var attack_id: = _get_next_attack_id()
	for i in _parent.current_stats.nb_projectiles:
		if exploding_effect != null :
			WeaponService.explode(exploding_effect, args)
			
	_parent._hitbox.player_attack_id = attack_id

	_parent.set_shooting(false)
