class_name FreezeInvulnerableEnemyEffectBehavior
extends EnemyEffectBehavior

# TODO: some enemies move but stay backwards while moving when ice slasher is equipped

var _current_stacks: int = 0
var _active_effects: Array = []
var _effects_proc_count: Dictionary = {}
var original_speed: int = 0
var original_attack_cd: int = 0


class ActiveEffect:
	var chance: float = 0.0
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
		if RunData.get_player_effect("weapon_freeze_invulnerable", player_index).size() > 0:
			return true

	if RunData.existing_weapon_has_effect("weapon_freeze_invulnerable"):
		return true

	return false


func on_hurt(hitbox: Hitbox) -> void :
	var from = hitbox.from
	
	if (is_instance_valid(from) and not "player_index" in from) or not is_instance_valid(from):
		return

	var from_player_index = from.player_index
	var effects = []
	var item_effects = RunData.get_player_effect("weapon_freeze_invulnerable", from_player_index)

	effects.append_array(item_effects)
	
	if hitbox:
		for effect in hitbox.effects:
			if effect.custom_key == "weapon_freeze_invulnerable":
				effects.push_back(effect.to_array())

	try_add_effects(effects, hitbox.scaling_stats)


func on_burned(burning_data: BurningData, from_player_index: int) -> void :
	var effects = RunData.get_player_effect("weapon_freeze_invulnerable", from_player_index)
	try_add_effects(effects, burning_data.scaling_stats)


func try_add_effects(effects: Array, scaling_stats: Array) -> void :
	for effect in effects:
		if WeaponService.find_scaling_stat(effect[1], scaling_stats) or effect[1] == "stat_all":
			add_active_effect(effect)


func add_active_effect(from_weapon_freeze_invulnerable_effect: Array) -> void :
	var chance = from_weapon_freeze_invulnerable_effect[3]
	if _parent.get("is_elite") != null:
		chance /= 5
	if Utils.get_chance_success(chance):
		var source_id = from_weapon_freeze_invulnerable_effect[0]
		var duration = from_weapon_freeze_invulnerable_effect[4]
		var max_stacks = from_weapon_freeze_invulnerable_effect[5]
		var outline_color = from_weapon_freeze_invulnerable_effect[6]
		var effect_color = from_weapon_freeze_invulnerable_effect[7]

		var active_effect: ActiveEffect = null

		active_effect = ActiveEffect.new()

		active_effect.source_id = source_id
		active_effect.timer = duration
		active_effect.duration_secs = duration
		active_effect.max_stacks = max_stacks
		active_effect.outline_color = Color(outline_color)
		active_effect.effect_color = Color(effect_color)
		
		original_speed = _parent.current_stats.speed
		if _parent.get_node("AttackBehavior").get("_current_cd") != null:
			original_attack_cd = _parent.get_node("AttackBehavior")._current_cd
		
		_parent.get_node("Collision").set_deferred("disabled",true)	# make enemy not block others
		_parent.get_node("Hitbox").set_deferred("deals_damage",false) # make the enemy deal no damage
		_parent.get_node("AnimationPlayer").current_animation = "[stop]" # freeze the animation
		_parent._hurtbox.call_deferred("disable") # to make invulnerable
		_parent.current_stats.set_deferred("speed", 0) # in case we need to process speed
		_parent.set_deferred("mirror_sprite_with_movement", false) # prevent them from turning while frozen
		_parent.sprite.set_deferred("self_modulate", active_effect.effect_color)
		if _parent._current_attack_behavior.get("_current_cd") != null:
			_parent._current_attack_behavior._current_cd = 9999
		
		_active_effects.push_back(active_effect)

		if not _parent.has_outline(active_effect.outline_color):
			_parent.add_outline(active_effect.outline_color, 1.0, 0.0)

		_effects_proc_count[source_id] = 1


func on_active_effect_timer_timed_out(active_effect: ActiveEffect):
	_parent.get_node("Collision").disabled = false
	_parent.get_node("Hitbox").deals_damage = true
	_parent.get_node("AnimationPlayer").current_animation = "idle"
	_parent._hurtbox.enable()
	_parent.current_stats.speed = original_speed
	_parent.mirror_sprite_with_movement = true
	_parent.sprite.self_modulate = Color.white
	if _parent._current_attack_behavior.get("_current_cd") != null:
		_parent._current_attack_behavior._current_cd = original_attack_cd

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

