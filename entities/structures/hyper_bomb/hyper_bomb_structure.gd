class_name HyperBombStructure
extends Structure

var cooldown = 0.25
onready var _sprite = $Animation / Sprite
onready var _shadow = $Animation / Shadow
onready var _original_texture = _sprite.texture
onready var _original_scale = Vector2(2,2)

func _ready() -> void :
	._ready()
	_sprite.texture = _original_texture
	_sprite.scale = _original_scale
	get_tree().create_timer(cooldown,false).connect("timeout",self,"on_explosion_timer_run_out")
	
func respawn() -> void :
	.respawn()
	_sprite.texture = _original_texture
	_sprite.scale = _original_scale
	get_tree().create_timer(cooldown,false).connect("timeout",self,"on_explosion_timer_run_out")

func on_explosion_timer_run_out() -> void:
	if dead or effects.size() <= 0: return

	var explosion_effect = effects[0]
	var args: = WeaponServiceExplodeArgs.new()
	args.pos = global_position
	args.damage = stats.damage
	args.accuracy = stats.accuracy
	args.crit_chance = stats.crit_chance
	args.crit_damage = stats.crit_damage
	args.burning_data = stats.burning_data
	args.scaling_stats = stats.scaling_stats
	args.from_player_index = player_index
#	args.damage_tracking_key = explosion_effect.tracking_key
	args.from = self
	_shadow.visible = false
	var _inst = WeaponService.explode(explosion_effect, args)
	die()

func _on_Area2D_body_entered(_body: Node) -> void :
	pass

func _on_Area2D_body_exited(_body: Node) -> void :
	pass
