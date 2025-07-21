class_name StructureSpawnerProjectile
extends PlayerProjectile

signal projectile_stopped(projectile)

var speed_multiplier

func _physics_process(delta):
	speed_multiplier = _weapon_stats.projectile_speed / 2
	# Prevent the projectile from leaving the screen
	if position.x < ZoneService.current_zone_min_position.x or position.x > ZoneService.current_zone_max_position.x:
		velocity.x = 0
	if position.y < ZoneService.current_zone_min_position.y or position.y > ZoneService.current_zone_max_position.y:
		velocity.y = 0
	# Slow the projectile down and stop in time
	if velocity.x > 0:
		velocity.x -= speed_multiplier * delta
	elif velocity.x < 0:
		velocity.x += speed_multiplier* delta
	if velocity.y > 0:
		velocity.y -= speed_multiplier * delta
	elif velocity.y < 0:
		velocity.y += speed_multiplier * delta
	if velocity.length() < 10:
		emit_signal("projectile_stopped",self)
		queue_free()

