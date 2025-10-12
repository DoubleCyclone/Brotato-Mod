class_name MultiStageChargeShootingBehavior
extends WeaponShootingBehavior

signal projectile_shot(projectile)

var charge_timer
var charge_timer_max_value = 3
var original_damage
var original_piercing

func _ready():
	charge_timer = Timer.new()
	charge_timer.wait_time = charge_timer_max_value
	add_child(charge_timer)

# TODO FIX TIMERS

func shoot(_distance: float) -> void :
	var multi_stage_charge_effect
	for effect in _parent.effects:
		if effect.key == "multi_stage_charge_effect":
			multi_stage_charge_effect = effect
	
	SoundManager.play(Utils.get_rand_element(_parent.current_stats.shooting_sounds), _parent.current_stats.sound_db_mod, 0.2)

	var initial_position: Vector2 = _parent.sprite.position

	_parent.set_shooting(true)	

	var attack_id: = _get_next_attack_id()
	for i in _parent.current_stats.nb_projectiles:
		var proj_rotation = rand_range(_parent.rotation - _parent.current_stats.projectile_spread, _parent.rotation + _parent.current_stats.projectile_spread)
		var knockback_direction: = Vector2(cos(proj_rotation), sin(proj_rotation))
		if multi_stage_charge_effect:
			original_damage = _parent.current_stats.damage
			original_piercing = _parent.current_stats.piercing
			var stage = get_charge_stage()
			_parent.current_stats.projectile_scene = multi_stage_charge_effect.projectile_stages[stage - 1]
			_parent.current_stats.damage *= multi_stage_charge_effect.damage_multipliers[stage - 1]
			_parent.current_stats.piercing += multi_stage_charge_effect.extra_piercings[stage - 1]
			print(charge_timer.time_left)
			var projectile = shoot_projectile(proj_rotation, knockback_direction)
			projectile._hitbox.player_attack_id = attack_id
			_parent.current_stats.damage = original_damage
			_parent.current_stats.piercing = original_piercing
		else:
			var projectile = shoot_projectile(proj_rotation, knockback_direction)
			projectile._hitbox.player_attack_id = attack_id
		charge_timer.start()

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


func get_charge_stage() -> int :
	return int(max(floor(charge_timer_max_value - charge_timer.time_left) ,1))
