class_name OilPuddle
extends Structure

export (Array, Resource) var pressed_sounds
export (PackedScene) var oil_skate

onready var _sprite = $Animation / Sprite
onready var _original_texture = _sprite.texture
var _original_effects: Array
var skate_instance: Structure
var spawn_effect


func respawn() -> void :
	.respawn()
	_sprite.texture = _original_texture


func _on_Area2D_body_entered(_body: Node) -> void :
	if dead or not(_body is Player): return
	for effect in effects:
		if effect.key == "oil_slider_structure_spawn" and !_body.get_node("Animation/Sprite").has_node("OilSliderSkate"):
			spawn_effect = effect
			spawn_skate(_body)
			die()


func _on_Area2D_body_exited(_body: Node) -> void :
	pass
	
	
func spawn_skate(_body: Node) -> void:
	print("spawn skate")
	SoundManager2D.play(Utils.get_rand_element(pressed_sounds), global_position, 5, 0.2)
	skate_instance = oil_skate.instance()
	skate_instance.position = skate_instance.position + Vector2(0,33)
	skate_instance.stats = spawn_effect.stats
	skate_instance.effects = effects
	skate_instance.spawn_effect = spawn_effect
	skate_instance.get_node("Animation/Sprite").scale = Vector2(3,3)
	_body.get_node("Animation/Sprite").call_deferred("add_child",skate_instance)


func apply_effect(_body: Node) -> void :
	_body.current_stats.speed *= 1.5
	_body.disable_hurtbox()
	
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
