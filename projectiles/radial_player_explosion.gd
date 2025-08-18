class_name RadialPlayerExplosion
extends PlayerExplosion

# This replaces the player explosion because you can put reference to the cause of the explosion (from)
func start_explosion() -> void :
	show()
	_hitbox.enable()
	_sprite.modulate.a = ProgressData.settings.explosion_opacity
	_animation_player.play("explode")
	set_physics_process(true)
	
