class_name RotatingProjectile
extends PlayerProjectile

export(float) var radius
export(int) var max_rotation
var d = 0
var distance_taken = 0 #should be a better way with this one

func _ready():
	# Start with random rotation for visual variety
	rotation = randf() * TAU

func _physics_process(delta: float) -> void :
#	._physics_process(delta)
	
	var max_range = PI * 2 * radius * max_rotation
	var previous_position = global_position
	
	# get player position
	var player = get_parent().get_parent().get_node("Entities/Player")
	d += delta
	position = player.position + Vector2(sin(d * _weapon_stats.projectile_speed) * radius, cos(d * _weapon_stats.projectile_speed) * radius)
	var distance_this_frame = global_position.distance_to(previous_position)
	# calculate distance taken every frame so that we can delete it when it exceeds max range (not the max range stat of the projectile)
	distance_taken += distance_this_frame
	if (distance_taken > max_range) :
		queue_free()
