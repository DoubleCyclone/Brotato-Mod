class_name OilSliderSkate
extends Structure

onready var _sprite = $Animation / Sprite
onready var _original_texture = _sprite.texture

var _original_effects: Array


func respawn() -> void :
	.respawn()
	_sprite.texture = _original_texture


func _on_Area2D_body_entered(_body: Node) -> void :
	if dead: return


func _on_Area2D_body_exited(_body: Node) -> void :
	pass


#func boost(boost_args: BoostArgs) -> void :
#	if can_be_boosted:
#		.boost(boost_args)
#		stats.damage *= 1.0 + boost_args.damage_boost / 100.0
#
#		_original_effects = effects
#		var new_explosion_effect = effects[0].duplicate()
#		new_explosion_effect.scale *= 1.0 + boost_args.range_boost / 100.0
#		effects = [new_explosion_effect]
#
#
#func boost_ended() -> void :
#	.boost_ended()
#	effects = _original_effects
