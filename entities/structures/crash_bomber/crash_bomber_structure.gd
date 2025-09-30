class_name CrashBomberStructure
extends Structure


signal thing_attached_died(thing_attached)


var timer
var cooldown = 0.25
var from_weapon
var thing_attached
export (Array, AudioStream) var explosion_sounds


func _ready() -> void :
	._ready()
	timer = get_tree().create_timer(cooldown,false)
	timer.connect("timeout",self,"on_explosion_timer_run_out")
	connect("thing_attached_died", self, "on_thing_attached_died")

	
func respawn() -> void :
	.respawn()
	timer = get_tree().create_timer(cooldown,false)
	timer.connect("timeout",self,"on_explosion_timer_run_out")


func _physics_process(delta: float) -> void :
	if thing_attached:
		position = Vector2.ZERO
		if thing_attached.dead:
			emit_signal("thing_attached_died", thing_attached)
			

func on_explosion_timer_run_out() -> void:
	if dead or effects.size() <= 0: return

	var explosion_effect = effects[0]
	var args: = WeaponServiceExplodeArgs.new()
	args.damage = stats.damage * 8
	args.accuracy = stats.accuracy
	args.crit_chance = stats.crit_chance
	args.crit_damage = stats.crit_damage
	args.burning_data = stats.burning_data
#	args.scaling_stats = stats.scaling_stats
	args.from_player_index = player_index
	args.from = from_weapon
#	args.damage_tracking_key = explosion_effect.tracking_key
	args.pos = global_position
	var _inst = WeaponService.explode(explosion_effect, args)
	_inst.connect("hit_something",self,"_on_explosion_hit_something")
#	for i in 8:
#		var random_offset = Vector2(global_position.x + rand_range(-80,80), global_position.y + rand_range(-80,80))
#		args.pos = random_offset
#		var _inst = WeaponService.explode(explosion_effect, args)
#		_inst.connect("hit_something",self,"_on_explosion_hit_something")
	SoundManager.play(Utils.get_rand_element(explosion_sounds), explosion_effect.sound_db_mod, 0.2)
	die()


func _on_explosion_hit_something(thing_hit, damage_dealt) -> void :
	RunData.manage_life_steal(from_weapon.current_stats, player_index)


func on_thing_attached_died(entity):
#	if is_instance_valid(instance):
	var time_left = timer.time_left
	entity.remove_child(self)
	Utils.get_scene_node().get_node("Entities").call_deferred("add_child",self)
	rotation_degrees = 0
	thing_attached = null
	position = entity.position
	timer.time_left = time_left


func _on_Area2D_body_entered(_body: Node) -> void :
	pass


func _on_Area2D_body_exited(_body: Node) -> void :
	pass
