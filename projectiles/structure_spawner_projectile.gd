class_name StructureSpawnerProjectile
extends PlayerProjectile

signal projectile_stopped(projectile)

func _physics_process(delta):
	if velocity.x > 0:
		velocity.x -= _weapon_stats.projectile_speed * delta
	elif velocity.x < 0:
		velocity.x += _weapon_stats.projectile_speed * delta
	if velocity.y > 0:
		velocity.y -= _weapon_stats.projectile_speed * delta
	elif velocity.y < 0:
		velocity.y += _weapon_stats.projectile_speed * delta
	if velocity.length() < 10:
		emit_signal("projectile_stopped",self)
		queue_free()

