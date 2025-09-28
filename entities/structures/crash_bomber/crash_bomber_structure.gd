class_name CrashBomberStructure
extends Structure

var cooldown = 0.25
var from_weapon
var thing_attached


func _ready() -> void :
	._ready()
	get_tree().create_timer(cooldown,false).connect("timeout",self,"on_explosion_timer_run_out")

	
func respawn() -> void :
	.respawn()
	get_tree().create_timer(cooldown,false).connect("timeout",self,"on_explosion_timer_run_out")


func _physics_process(delta: float) -> void :
	if thing_attached:
		position = Vector2.ZERO


func on_explosion_timer_run_out() -> void:
	if dead or effects.size() <= 0: return

	var explosion_effect = effects[0]
	var args: = WeaponServiceExplodeArgs.new()
	args.damage = stats.damage
	args.accuracy = stats.accuracy
	args.crit_chance = stats.crit_chance
	args.crit_damage = stats.crit_damage
	args.burning_data = stats.burning_data
	args.scaling_stats = stats.scaling_stats
	args.from_player_index = player_index
	args.from = from_weapon
#	args.damage_tracking_key = explosion_effect.tracking_key
	for i in 8:
		var random_offset = Vector2(global_position.x + rand_range(-80,80), global_position.y + rand_range(-80,80))
		args.pos = random_offset
		var _inst = WeaponService.explode(explosion_effect, args)
		_inst.connect("hit_something",self,"_on_explosion_hit_something")
	die()


func _on_explosion_hit_something(thing_hit, damage_dealt) -> void :
	RunData.manage_life_steal(from_weapon.current_stats, player_index)


func _on_Area2D_body_entered(_body: Node) -> void :
	pass


func _on_Area2D_body_exited(_body: Node) -> void :
	pass
