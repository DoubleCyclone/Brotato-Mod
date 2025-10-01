class_name StructureAttachingProjectile
extends PlayerProjectile


signal projectile_stopped(projectile)


func _physics_process(_delta: float) -> void :
	# Prevent the projectile from leaving the screen
	if position.x < ZoneService.current_zone_min_position.x or position.x > ZoneService.current_zone_max_position.x:
		_time_until_max_range = 0
	if position.y < ZoneService.current_zone_min_position.y or position.y > ZoneService.current_zone_max_position.y:
		_time_until_max_range = 0


func stop() -> void :
	if _enable_stop_delay:
		return

	_hitbox.active = false
	_hitbox.disable()
	_hitbox.ignored_objects.clear()

	if stop_delay > 0:
		_enable_stop_delay = true
		_sprite.hide()
	else:
		emit_signal("projectile_stopped", self)
		_return_to_pool()
	


func _return_to_pool() -> void :
	hide()
	velocity = Vector2.ZERO
	_hitbox.collision_layer = _original_collision_layer
	_enable_stop_delay = false
	_elapsed_delay = 0
	_sprite.material = null
	_animation_player.stop()
	set_physics_process(false)

	Utils.disconnect_all_signal_connections(self, "hit_something")
	Utils.disconnect_all_signal_connections(self._hitbox, "killed_something")
	Utils.disconnect_all_signal_connections(self, "projectile_stopped")

	if is_instance_valid(_hitbox.from) and _hitbox.from.has_signal("died") and _hitbox.from.is_connected("died", self, "on_entity_died"):
		_hitbox.from.disconnect("died", self, "on_entity_died")

	var main = Utils.get_scene_node()
	main.add_node_to_pool(self)
