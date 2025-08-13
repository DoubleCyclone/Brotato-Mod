class_name RockWeaponEnergySceneEffectBehavior
extends SceneEffectBehavior

export (PackedScene) var energy_tank


func _ready() -> void :
	if should_check():
		var _err = _entity_spawner_ref.connect("players_spawned",self,"_on_EntitySpawner_players_spawned")
		var _err2 = _entity_spawner_ref.connect("enemy_spawned",self,"_on_EntitySpawner_enemy_spawned")


func should_check() -> bool:
	if RunData.existing_weapon_has_effect("weapon_energy_bar"):
		return true
	for player_index in RunData.get_player_count():
		if RunData.get_player_effect("weapon_energy_bar", player_index) > 0:
			return true
	return false


func _on_EntitySpawner_players_spawned(players: Array) -> void :
	# Get all players
	for player in players:
		# Keep players with this effect
		if RunData.get_player_effect("weapon_energy_bar", player.player_index) > 0 :
			# Get all weapons (not the empty slots)
			var weapons = []
			for weapon in player._weapons_container.get_children():
				if weapon.script:
					weapons.append(weapon)
					# Add energy tank to every weapon
					var energy_tank_instance = energy_tank.instance()
					weapon.add_child(energy_tank_instance)
			
		
func _on_EntitySpawner_enemy_spawned(enemy: Enemy) -> void :
	enemy.connect("took_damage",self,"_on_enemy_took_damage")
	
	
func _on_enemy_took_damage(unit, value, knockback_direction, is_crit, is_dodge, is_protected, armor_did_something, args, hit_type) -> void :
	var energy_tank = args.hitbox.from.get_node("EnergyTank")
	energy_tank.fill(value)
	# TODO : do something when tank fills up
	print(args.hitbox.from.get_node("EnergyTank").current_value)
