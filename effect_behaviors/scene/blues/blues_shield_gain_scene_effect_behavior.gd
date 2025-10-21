class_name BluesShieldGainSceneEffectBehavior
extends SceneEffectBehavior

export (PackedScene) var energy_tank
var shield_gain_chance

func _ready() -> void :
	if should_check():
#		var _err = _entity_spawner_ref.connect("players_spawned",self,"_on_EntitySpawner_players_spawned")
		var _err2 = _entity_spawner_ref.connect("enemy_spawned",self,"_on_EntitySpawner_enemy_spawned")


func should_check() -> bool:
	if RunData.existing_weapon_has_effect("blues_shield_gain_on_kill"):
		return true
	for player_index in RunData.get_player_count():
		if RunData.get_player_effect("blues_shield_gain_on_kill", player_index) > 0:
			shield_gain_chance = RunData.get_player_effect("blues_shield_gain_on_kill", player_index)
			return true
	return false
		
		
func _on_EntitySpawner_enemy_spawned(enemy: Enemy) -> void :
	enemy.connect("died",self,"_on_enemy_died")
	
	
func _on_enemy_died(entity, die_args) -> void :
	if !Utils.get_chance_success(shield_gain_chance):
		return
	if die_args.killed_by_player_index < 0:
		return
	# Get Player
	var player = Utils.get_scene_node()._players[die_args.killed_by_player_index]
	player._hit_protection += 1
	

func give_feedback(value, stat_name : String, player_index : int, offset : Vector2 = Vector2(0,0), icon: Resource = null, always_display: bool = false, need_translate: bool = true) -> void : 
	var floating_text_manager = Utils.get_scene_node().get_node("FloatingTextManager")
	var player = floating_text_manager.players[player_index]
	set_message_translation(true)
	if value > 0:
		floating_text_manager.display(str("+",value," ",tr(stat_name.to_upper())), player.global_position + offset, Color.cyan, icon)
	else:
		floating_text_manager.display(str(value," ",tr(stat_name.to_upper())), player.global_position + offset, Color.red, icon)
