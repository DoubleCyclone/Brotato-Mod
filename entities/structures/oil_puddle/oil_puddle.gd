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
			apply_effect(_body)
			var timer = get_tree().create_timer(effect.effect_timer,false)
			timer.connect("timeout",self,"on_timer_timeout",[_body])	
			die()

func _on_Area2D_body_exited(_body: Node) -> void :
	pass
# TODO only spawn skate here, have its logic in its own script, stop pushing other puddles, make sprite bigger
func apply_effect(_body: Node) -> void :
	print("apply buff")
	SoundManager2D.play(Utils.get_rand_element(pressed_sounds), global_position, 5, 0.2)
	_body.current_stats.speed *= 1.5
	_body.disable_hurtbox()
	skate_instance = oil_skate.instance() 
	skate_instance.position = skate_instance.position + Vector2(0,33)
#	skate_instance.connect("hit_something", self, "amogus")
	skate_instance.stats = spawn_effect.stats
	_body.get_node("Animation/Sprite").call_deferred("add_child",skate_instance)
#	Utils.get_scene_node().call_deferred("add_child",skate_instance)


func on_timer_timeout(_body: Node) -> void :
	print("unapply buff")
	_body.current_stats.speed /= 1.5
	_body.enable_hurtbox()
	skate_instance.queue_free()
	
func _on_Hitbox_hit_something(thing_hit, damage_dealt):
	print("hit something")
	
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
