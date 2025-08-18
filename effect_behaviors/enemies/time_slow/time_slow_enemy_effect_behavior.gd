class_name TimeSlowEnemyEffectBehavior
extends EnemyEffectBehavior

var _current_stacks: int = 0
var _active_effects: Array = []
var _effects_proc_count: Dictionary = {}
var original_speed: int = 0


class ActiveEffect:
	var chance: float = 0.0
	var amount: float = 0.0
	var total_amount: float = 0.0
	var duration_secs: float = 0.0
	var timer: float = 0.0
	var source_id: String = ""
	var current_stacks: int = 0
	var max_stacks: int = 1
	var outline_color: Color
	var effect_color: Color

func _process(delta):
	for active_effect in _active_effects:
		active_effect.timer -= delta
		if active_effect.timer <= 0.0:
			on_active_effect_timer_timed_out(active_effect)


func should_add_on_spawn() -> bool:
	for player_index in RunData.get_player_count():
		if RunData.get_player_effect("effect_weapon_time_slow", player_index).size() > 0:
			return true

	if RunData.existing_weapon_has_effect("effect_weapon_time_slow"):
		return true

	return false


func on_hurt(hitbox: Hitbox) -> void :
	
	var from = hitbox.from

	if (is_instance_valid(from) and not "player_index" in from) or not is_instance_valid(from):
		return

	var from_player_index = from.player_index
	var effects = []
	var item_effects = RunData.get_player_effect("effect_weapon_time_slow", from_player_index)

	
	effects.append_array(item_effects)

	if hitbox:
		for effect in hitbox.effects:
			if effect.custom_key == "effect_weapon_time_slow":
				effects.push_back(effect.to_array())

	try_add_effects(effects, hitbox.scaling_stats)


func on_burned(burning_data: BurningData, from_player_index: int) -> void :
	var effects = RunData.get_player_effect("effect_weapon_time_slow", from_player_index)
	try_add_effects(effects, burning_data.scaling_stats)


func try_add_effects(effects: Array, scaling_stats: Array) -> void :
	for effect in effects:
		if WeaponService.find_scaling_stat(effect[1], scaling_stats) or effect[1] == "stat_all":
			add_active_effect(effect)


func add_active_effect(from_weapon_time_slow_effect: Array) -> void :
	if _parent.dead : 
		return
		
	var chance = from_weapon_time_slow_effect[3]

	if Utils.get_chance_success(chance):
		var source_id = from_weapon_time_slow_effect[0]
		var amount = from_weapon_time_slow_effect[4]
		var duration = from_weapon_time_slow_effect[5]
		var max_stacks = from_weapon_time_slow_effect[6]
		var outline_color = from_weapon_time_slow_effect[7]
		var effect_color = from_weapon_time_slow_effect[8]
		
		var already_exists: bool = false
		var active_effect: ActiveEffect = null
		
		for existing_active_effect in _active_effects:
			if existing_active_effect.source_id == source_id:
				already_exists = true
				active_effect = existing_active_effect
				break
				
		if already_exists:
			
			active_effect.max_stacks = max(active_effect.max_stacks, max_stacks) as int
			active_effect.duration_secs = max(active_effect.duration_secs, duration)
			active_effect.amount = max(active_effect.amount, amount)
			active_effect.timer = active_effect.duration_secs

			if active_effect.current_stacks >= active_effect.max_stacks:
				return

			active_effect.current_stacks += 1
			_parent.current_stats.set_deferred("speed", _parent.current_stats.speed * (1 - active_effect.amount * active_effect.current_stacks)) 
			_effects_proc_count[source_id] += 1
		else:
			active_effect = ActiveEffect.new()

			active_effect.source_id = source_id
			active_effect.amount = amount
			active_effect.timer = duration
			active_effect.duration_secs = duration
			active_effect.max_stacks = max_stacks
			active_effect.outline_color = Color(outline_color)
			active_effect.effect_color = Color(effect_color)
			active_effect.current_stacks = 1
			
			original_speed = _parent.current_stats.speed
			
			_parent.current_stats.set_deferred("speed", _parent.current_stats.speed * (1 - active_effect.amount * active_effect.current_stacks)) 
			_parent.sprite.set_deferred("self_modulate", active_effect.effect_color)
			
			_active_effects.push_back(active_effect)

			if not _parent.has_outline(active_effect.outline_color):
				_parent.add_outline(active_effect.outline_color, 1.0, 0.0)

			_effects_proc_count[source_id] = 1


func on_active_effect_timer_timed_out(active_effect: ActiveEffect):
	_parent.current_stats.speed = original_speed
	_parent.sprite.self_modulate = Color.white

	for i in _active_effects.size():
		if _active_effects[i].source_id == active_effect.source_id:
			_active_effects.remove(i)
			break

	var remove_outline = true

	for remaining_active_effect in _active_effects:
		if remaining_active_effect.outline_color == active_effect.outline_color:
			remove_outline = false
			break

	if remove_outline:
		_parent.remove_outline(active_effect.outline_color)

