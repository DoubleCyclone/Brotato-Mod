class_name ProjectileShield
extends Node

var proj_array = []
var max_projectile_count = 4

func _ready():
	proj_array.resize(max_projectile_count)
