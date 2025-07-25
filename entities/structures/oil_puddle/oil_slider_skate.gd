class_name OilSliderSkate
extends Structure

onready var _sprite = $Animation / Sprite

var _original_effects: Array
var spawn_effect
var player


func _ready():
	player = get_parent().get_parent().get_parent()
	if !player.get_node("Animation/Sprite").has_node("OilSliderSkate"): return
	var timer = get_tree().create_timer(spawn_effect.effect_timer,false)
	timer.connect("timeout",self,"on_timer_timeout",[player])	
	player.current_stats.speed *= spawn_effect.speed_modifier
	player.get_node("Hurtbox").monitoring = false
	

func respawn() -> void :
	player = get_parent().get_parent().get_parent()
	if !player.get_node("Animation/Sprite").has_node("OilSliderSkate"): return
	var timer = get_tree().create_timer(spawn_effect.effect_timer,false)
	timer.connect("timeout",self,"on_timer_timeout",[player])	
	player.current_stats.speed *= spawn_effect.speed_modifier
	player.disable_hurtbox()


func _on_Area2D_body_entered(_body: Node) -> void :
	if dead: return
	if _body is Player or _body is Structure: return
	var scaled_damage = WeaponService.apply_scaling_stats_to_damage(stats.damage, stats.scaling_stats, player.player_index)
	var damage_value = _body.get_damage_value(scaled_damage, player.player_index)
	var args = TakeDamageArgs.new(player.player_index)
	_body.take_damage(damage_value.value, args)


func _on_Area2D_body_exited(_body: Node) -> void :
	pass


func on_timer_timeout(player: Node) -> void :
	player.current_stats.speed /= spawn_effect.speed_modifier
	player.get_node("Hurtbox").monitoring = true
	queue_free()
	
# TODO: when getting on the skate while taking damage, invulnerability does not apply (or the newly applied one is removed by the old timer)
# TODO: add boost functions to structures maybe

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
