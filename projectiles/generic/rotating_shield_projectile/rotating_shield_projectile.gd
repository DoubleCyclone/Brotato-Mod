class_name RotatingShieldProjectile
extends PlayerProjectile

onready var _projectiles = $ProjectileContainer/Projectiles

func _physics_process(_delta: float) -> void :
	if rotation_speed != 0:
		rotation_degrees += 25

	if _ticks_until_max_range <= 0:
		stop()
	_ticks_until_max_range -= 1

	if get_node("ProjectileContainer/Projectiles").get_child_count() <= 0:
		print("ciapjowfpo")
		stop()
	else:
		var projectiles = _projectiles.get_children()
		for proj in projectiles:
#			proj.position = Vector2.ZERO
			proj.origin = position

