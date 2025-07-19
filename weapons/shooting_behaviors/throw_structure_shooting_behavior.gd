class_name ThrowStructureShootingBehavior
extends WeaponShootingBehavior

signal projectile_shot(projectile)

export (Texture) var throw_sprite
export (Texture) var cooldown_sprite
export (PackedScene) var structure_scene


func shoot(_distance: float) -> void :
	SoundManager.play(Utils.get_rand_element(_parent.current_stats.shooting_sounds), _parent.current_stats.sound_db_mod, 0.2)
#	_parent.get_node("Sprite").texture = throw_sprite
#
#	var initial_position: Vector2 = _parent.sprite.position
#
	_parent.set_shooting(true)
#
#
#	var attack_id: = _get_next_attack_id()
#	for i in _parent.current_stats.nb_projectiles:
#		var proj_rotation = rand_range(_parent.rotation - _parent.current_stats.projectile_spread, _parent.rotation + _parent.current_stats.projectile_spread)
#		var knockback_direction: = Vector2(cos(proj_rotation), sin(proj_rotation))
#
#
#	_parent.tween.interpolate_property(
#		_parent.sprite, 
#		"position", 
#		initial_position, 
#		Vector2(initial_position.x - _parent.current_stats.recoil, initial_position.y), 
#		_parent.current_stats.recoil_duration, 
#		Tween.TRANS_EXPO, 
#		Tween.EASE_OUT
#	)
#
#	_parent.tween.start()
#	yield(_parent.tween, "tween_all_completed")
#
#	_parent.tween.interpolate_property(
#		_parent.sprite, 
#		"position", 
#		_parent.sprite.position, 
#		initial_position, 
#		_parent.current_stats.recoil_duration, 
#		Tween.TRANS_EXPO, 
#		Tween.EASE_OUT
#	)
#
#	_parent.tween.start()
#	yield(_parent.tween, "tween_all_completed")
#
#	_parent.get_node("Sprite").texture = cooldown_sprite
	_parent.set_shooting(false)
