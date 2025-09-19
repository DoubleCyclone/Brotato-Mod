class_name RotatingProjectile
extends PlayerProjectile

export(float) var radius
export(int) var max_rotation
var d = 0
var distance_taken = 0
var origin_object
var rotating_speed = 0
var offset = randf() * TAU


func _physics_process(delta: float) -> void :
	if origin_object == null:
		origin_object = _hitbox.from.get_parent().get_parent()
	var max_range = PI * 2 * radius * max_rotation
	var previous_position = global_position
	d += delta
	position = origin_object.position + Vector2(cos(d * rotating_speed + offset) * radius, sin(d * rotating_speed + offset) * radius)
	var distance_this_frame = global_position.distance_to(previous_position)
	# calculate distance taken every frame so that we can delete it when it exceeds max range (not the max range stat of the projectile)
	distance_taken += distance_this_frame
	if (distance_taken > max_range) :
		queue_free()


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
		queue_free()

