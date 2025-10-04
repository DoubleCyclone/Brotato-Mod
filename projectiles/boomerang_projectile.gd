class_name BoomerangProjectile
extends PlayerProjectile

var d = 0
var player
var initial_weapon_rotation

func _ready():
	# Start with random rotation for visual variety
	rotation = randf() * TAU
	player = get_parent().get_parent().get_node("Entities/Player")
	

func _physics_process(delta: float) -> void :
	if !initial_weapon_rotation:
		initial_weapon_rotation = _hitbox.from.rotation_degrees
		
	var radius = _max_range / 4
	d += delta
	var progress = d * _weapon_stats.projectile_speed
	
	# Convert weapon rotation to radians for math functions
	var weapon_rotation_rad = deg2rad(initial_weapon_rotation)
	
	# Create elliptical trajectory rotated by weapon rotation
	var ellipse_x = (cos(progress) - 1) * radius
	var ellipse_y = sin(progress) * radius * 0.75
	
	# Rotate the ellipse based on weapon rotation
	var rotated_x = ellipse_x * cos(weapon_rotation_rad) - ellipse_y * sin(weapon_rotation_rad)
	var rotated_y = ellipse_x * sin(weapon_rotation_rad) + ellipse_y * cos(weapon_rotation_rad)
	
	# Apply direction and set position
	position = player.position + Vector2(-rotated_x, -rotated_y)
	
	# Queue free after completing full loop (progress >= 2π)
	if progress >= 2 * PI:
		queue_free()

