class_name RadialPlayerExplosion
extends PlayerExplosion

export (Array, Resource) var explosion_effects

# This replaces the player explosion because you can put reference to the cause of the explosion (from)
func start_explosion() -> void :
	show()
	for effect in explosion_effects:
		_hitbox.effects.append(effect)
	_hitbox.enable()
	_sprite.modulate.a = ProgressData.settings.explosion_opacity
	_animation_player.play("explode")
	set_physics_process(true)
	
