class_name OildSliderSkate
extends Node2D

#TODO : Try this with a node and a hitbox instead. 

onready var _hitbox = $Hitbox
onready var _sprite = $Sprite as Sprite
var _original_effects: Array
var spawn_effect
var player
var from_weapon


func _ready():
	player = get_parent().get_parent().get_parent()
	if !player.get_node("Animation/Sprite").has_node("OilSliderSkate"): return
	var timer = get_tree().create_timer(spawn_effect.effect_timer,false)
	timer.connect("timeout",self,"on_timer_timeout",[player])	
	player.current_stats.speed *= spawn_effect.speed_modifier
	player.get_node("Hurtbox").monitoring = false
	var hitbox_args = Hitbox.HitboxArgs.new().set_from_weapon_stats(spawn_effect.stats)
	var scaled_damage = WeaponService.apply_scaling_stats_to_damage(spawn_effect.stats.damage, spawn_effect.stats.scaling_stats, player.player_index)
	_hitbox.set_damage(scaled_damage, hitbox_args)
	_hitbox.crit_damage = 2
	_hitbox.crit_chance = spawn_effect.stats.crit_chance + RunData.get_stat("stat_crit_chance", player.player_index) / 100
	_hitbox.from = from_weapon

func respawn() -> void :
	player = get_parent().get_parent().get_parent()
	if !player.get_node("Animation/Sprite").has_node("OilSliderSkate"): return
	var timer = get_tree().create_timer(spawn_effect.effect_timer,false)
	timer.connect("timeout",self,"on_timer_timeout",[player])	
	player.current_stats.speed *= spawn_effect.speed_modifier
	player.get_node("Hurtbox").monitoring = false
	var hitbox_args = Hitbox.HitboxArgs.new().set_from_weapon_stats(spawn_effect.stats)
	var scaled_damage = WeaponService.apply_scaling_stats_to_damage(spawn_effect.stats.damage, spawn_effect.stats.scaling_stats, player.player_index)
	_hitbox.set_damage(scaled_damage, hitbox_args)
	_hitbox.crit_damage = 2
	_hitbox.crit_chance = spawn_effect.stats.crit_chance + RunData.get_stat("stat_crit_chance", player.player_index) / 100
	_hitbox.from = from_weapon
	
	
func on_timer_timeout(player: Node) -> void :
	player.current_stats.speed /= spawn_effect.speed_modifier
	player.get_node("Hurtbox").monitoring = true
	queue_free()


