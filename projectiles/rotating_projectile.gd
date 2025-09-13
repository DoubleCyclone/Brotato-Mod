class_name RotatingProjectile
extends PlayerProjectile

export(float) var radius
export(int) var max_rotation
var d = 0
var distance_taken = 0 #should be a better way with this one
var rotating = true
var origin
var around_player_only = true
var rotating_speed = 0

func _ready():
	# Start with random rotation for visual variety
	rotation = randf() * TAU

func _physics_process(delta: float) -> void :
	if rotating and rotating_speed != 0:
		if around_player_only or origin == null:
			var player = _hitbox.from.get_parent().get_parent()
			origin = player.global_position
		var max_range = PI * 2 * radius * max_rotation
		var previous_position = global_position
		d += delta
		position = origin + Vector2(sin(d * rotating_speed) * radius, cos(d * rotating_speed) * radius)
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

#func attach(attach_to: Vector2, attach_idle_angle: float) -> void :
#	position = attach_to - _attach.position
#	_idle_angle = attach_idle_angle
