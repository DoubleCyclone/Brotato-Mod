class_name StructureSpawnerProjectile
extends PlayerProjectile

signal projectile_stopped(projectile)

var speed_multiplier
var max_scale = Vector2(1.75,1.75)
var min_scale = Vector2(1,1)
var max_scale_reached = false

#TODO rework this and buff structure so that it explodes faster
func _physics_process(delta):
	if rotation_speed != 0:
		rotation_degrees -= 20
	
	speed_multiplier = _weapon_stats.projectile_speed / 1.5
	if not max_scale_reached and scale < max_scale:
		scale.x += delta
		scale.y += delta
		if scale >= max_scale:
			max_scale_reached = true
	elif max_scale_reached and scale > min_scale:
		scale.x -= delta
		scale.y -= delta
	# Prevent the projectile from leaving the screen
	if position.x < ZoneService.current_zone_min_position.x or position.x > ZoneService.current_zone_max_position.x:
		velocity.x = 0
	if position.y < ZoneService.current_zone_min_position.y or position.y > ZoneService.current_zone_max_position.y:
		velocity.y = 0
	# Slow the projectile down and stop in time
	if velocity.x > 0:
		velocity.x -= speed_multiplier * delta
	elif velocity.x < 0:
		velocity.x += speed_multiplier * delta
	if velocity.y > 0:
		velocity.y -= speed_multiplier * delta
	elif velocity.y < 0:
		velocity.y += speed_multiplier * delta
	if velocity.length() < 10:
		emit_signal("projectile_stopped",self)
		queue_free()

