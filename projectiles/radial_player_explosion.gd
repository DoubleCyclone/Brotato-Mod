class_name RadialPlayerExplosion
extends PlayerExplosion

export (Array, Resource) var explosion_effects

func start_explosion() -> void :
	show()
	_hitbox.effects = explosion_effects.duplicate()
	_hitbox.enable()
	_hitbox.from = self
	_sprite.modulate.a = ProgressData.settings.explosion_opacity
	_animation_player.play("explode")
	set_physics_process(true)
	
