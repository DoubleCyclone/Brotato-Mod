class_name AttachStructureShootingBehavior
extends WeaponShootingBehavior

signal projectile_shot(projectile)

var structure_scene
var structure_spawn_effect
var sound_effect

func shoot(_distance: float) -> void :
	for effect in _parent.effects:
		if effect.key == "effect_bomb_spawn":
			structure_spawn_effect = effect
			structure_scene = effect.structure_scene
			if effect.spawn_sound_effect:	
				sound_effect = effect.spawn_sound_effect
			
	SoundManager.play(Utils.get_rand_element(_parent.current_stats.shooting_sounds), _parent.current_stats.sound_db_mod, 0.2)

	var initial_position: Vector2 = _parent.sprite.position

	_parent.set_shooting(true)

	var attack_id: = _get_next_attack_id()
	for i in _parent.current_stats.nb_projectiles:
		var proj_rotation = rand_range(_parent.rotation - _parent.current_stats.projectile_spread, _parent.rotation + _parent.current_stats.projectile_spread)
		var knockback_direction: = Vector2(cos(proj_rotation), sin(proj_rotation))
		var projectile = shoot_projectile(proj_rotation, knockback_direction)
		projectile._hitbox.player_attack_id = attack_id
		projectile.connect("hit_something",self,"on_projectile_hit_something", [projectile])
		projectile.connect("projectile_stopped", self, "on_projectile_stopped")
		
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
	
func on_projectile_hit_something(thing_hit, damage_dealt, projectile):
#	if projectile._piercing != 0 && projectile._bounce != 0:
#		return
	var instance = structure_scene.instance()
	instance.from_weapon = _parent
	instance.player_index = _parent.player_index
	instance.stats = _parent.current_stats
	instance.cooldown = structure_spawn_effect.timer_cooldown
	for effect in _parent.effects:
		if effect.key == "effect_bomb_spawn":
			instance.effects = effect.effects #TODO : maybe append	
	thing_hit.call_deferred("add_child", instance)
	instance.thing_attached = thing_hit
	instance.rotation_degrees = projectile.rotation_degrees - 90
	if sound_effect:
		SoundManager.play(sound_effect, -5, 0.2)
#	thing_hit.connect("died", self, "on_thing_hit_died", [instance])
	
	
func on_projectile_stopped(projectile):
	if projectile._ticks_until_max_range == 0:
		var instance = structure_scene.instance()
		instance.from_weapon = _parent
		instance.player_index = _parent.player_index
		instance.stats = _parent.current_stats
		instance.cooldown = structure_spawn_effect.timer_cooldown
		for effect in _parent.effects:
			if effect.key == "effect_bomb_spawn":
				instance.effects = effect.effects #TODO : maybe append
		instance.position = projectile.position
		Utils.get_scene_node().get_node("Entities").add_child(instance)
		if sound_effect:
			SoundManager.play(sound_effect, -5, 0.2)
	

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
