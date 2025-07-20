class_name StructureSpawnerProjectile
extends PlayerProjectile

signal projectile_stopped(projectile)

func _physics_process(_delta: float) -> void :
	if velocity.x > 0:
		velocity.x -= _weapon_stats.projectile_speed * _delta
	elif velocity.x < 0:
		velocity.x += _weapon_stats.projectile_speed * _delta
	if velocity.y > 0:
		velocity.y -= _weapon_stats.projectile_speed * _delta
	elif velocity.y < 0:
		velocity.y += _weapon_stats.projectile_speed * _delta
	if velocity.length() < 10:
		emit_signal("projectile_stopped",self)
		queue_free()
		
#func spawn_bomb(structure_scene):
#	var instance = structure_scene.instance()
#	instance.player_index = player_index
#	instance.position = position
#	instance.stats = _weapon_stats
#	instance.effects = _hitbox.effects[0].effects
#	Utils.get_scene_node().get_node("Entities").add_child(instance)
