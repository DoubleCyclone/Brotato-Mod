class_name BoomerangProjectile
extends PlayerProjectile

var radius
var max_rotation = 1.1
var d = 0
var distance_taken = 0 
var direction = 1
var player
var distance_this_frame

func _ready():
	# Start with random rotation for visual variety
	rotation = randf() * TAU
	player = get_parent().get_parent().get_node("Entities/Player")
	var player_sprite = player.get_node("Animation/Sprite")
	if player_sprite.scale.x > 0:
		direction = 1
	else:
		direction = -1

func _physics_process(delta: float) -> void :
	radius = _max_range / 3
	d += delta
	var progress = d * _weapon_stats.projectile_speed

	# Horizontal elliptical trajectory (swaps x/y from previous version)
	var ellipse_x = (cos(progress) - 1) * radius * direction  # -1 makes it start and end at 0
	var ellipse_y = sin(progress) * radius * 0.75  # 0.75 controls vertical "squash"
	position = player.position + Vector2(-ellipse_x, -ellipse_y)

	# Queue free after completing full loop (progress >= 2π)
	if progress >= 2 * PI:
		queue_free()
