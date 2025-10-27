class_name BluesShieldGainSceneEffectBehavior
extends SceneEffectBehavior

export (AudioStream) var blues_whistle
var shield_gain_chance

func _ready() -> void :
	if should_check():
		var _err = _entity_spawner_ref.connect("players_spawned",self,"_on_EntitySpawner_players_spawned")
		var _err2 = _entity_spawner_ref.connect("enemy_spawned",self,"_on_EntitySpawner_enemy_spawned")
		if RunData.current_wave == 1 :
			SoundManager.play(blues_whistle, 0, 0)

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
	if die_args.killed_by_player_index < 0 || die_args.killed_by_player_index == 123:
		return
	# Get Player
	var player = Utils.get_scene_node()._players[die_args.killed_by_player_index]
	player._hit_protection += 1
	
	
func _on_EntitySpawner_players_spawned(players: Array) -> void :
	# Get all players
	for player in players:
		# Keep players with this effect
		if RunData.get_player_effect("blues_shield_gain_on_kill", player.player_index) > 0 :
			var _err = player.connect("took_damage", self, "on_player_took_damage", [player])


func on_player_took_damage(unit, value, knockback_direction, is_crit, is_dodge, is_protected, armor_did_something, args, hit_type, is_oneshot, player) -> void :
	if !args.hitbox:
		return
	if !args.hitbox.from:
		return
	if is_protected :
		var player_armor = RunData.get_stat("stat_armor", player.player_index)
		# scale damage 
		var scaling_stats = []
		scaling_stats.append(["stat_armor", 0.2])
		
		# scale with percent damage manually
		var scaled_damage = WeaponService.apply_scaling_stats_to_damage(args.hitbox.damage, scaling_stats, player.player_index)		
		scaled_damage = scaled_damage + scaled_damage * RunData.get_stat("stat_percent_damage", player.player_index) / 100.0
		
		if args.hitbox.get_parent().name.find("EnemyProjectile") :
			var weapon_stats = RangedWeaponStats.new()
			weapon_stats.nb_projectiles = RunData.get_stat("projectiles", player.player_index)
			weapon_stats.piercing = RunData.get_stat("piercing", player.player_index)
			weapon_stats.piercing_dmg_reduction = 0.5 - RunData.get_stat("piercing_damage", player.player_index) / 100.0
			weapon_stats.bounce = RunData.get_stat("bounce", player.player_index)
			weapon_stats.bounce_dmg_reduction = 0.5 - RunData.get_stat("bounce_damage", player.player_index) / 100.0
			weapon_stats.damage = scaled_damage
			weapon_stats.max_range = 10000

			var proj_args = WeaponServiceSpawnProjectileArgs.new()
			proj_args.from_player_index = player.player_index
			
			WeaponService.manage_special_spawn_projectile(player, weapon_stats, rand_range( - PI, PI), true, _entity_spawner_ref, player, proj_args)
		else:
			args.hitbox.from.take_damage(scaled_damage, args)
			
		

func give_feedback(value, stat_name : String, player_index : int, offset : Vector2 = Vector2(0,0), icon: Resource = null, always_display: bool = false, need_translate: bool = true) -> void : 
	var floating_text_manager = Utils.get_scene_node().get_node("FloatingTextManager")
	var player = floating_text_manager.players[player_index]
	set_message_translation(true)
	if value > 0:
		floating_text_manager.display(str("+",value," ",tr(stat_name.to_upper())), player.global_position + offset, Color.cyan, icon)
	else:
		floating_text_manager.display(str(value," ",tr(stat_name.to_upper())), player.global_position + offset, Color.red, icon)
