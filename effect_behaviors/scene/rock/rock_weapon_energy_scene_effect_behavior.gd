class_name RockWeaponEnergySceneEffectBehavior
extends SceneEffectBehavior

# Maybe add an indicator when the tank is filled like a popup

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
					var err = energy_tank_instance.connect("tank_filled", self, "_on_EnergyTank_tank_filled")
					var err2 = energy_tank_instance.connect("tank_full", self, "_on_EnergyTank_tank_full")
					weapon.add_child(energy_tank_instance)
			
		
func _on_EntitySpawner_enemy_spawned(enemy: Enemy) -> void :
	enemy.connect("took_damage",self,"_on_enemy_took_damage")
	
	
func _on_enemy_took_damage(unit, value, knockback_direction, is_crit, is_dodge, is_protected, armor_did_something, args, hit_type) -> void :
	# Temporary solution?
	if !args.hitbox: return
	var energy_tank = args.hitbox.from.get_node("EnergyTank")
	if energy_tank:
		energy_tank.fill(value)
		# TODO : do something when tank fills up
	

func _on_EnergyTank_tank_filled(energy_tank, last_added_amount) -> void :
	# TODO check extra projectiles like charged shot they don't scale
	# TODO put rock effect 2 back to the character

	# Current stats for updating, original stats for checking (original might suffice but idk)
	var weapon_stats = energy_tank.weapon.stats
	var weapon_current_stats = energy_tank.weapon.current_stats
	var stats_list = [
		weapon_current_stats.cooldown,
		weapon_current_stats.damage,
		weapon_current_stats.crit_chance,
		weapon_current_stats.lifesteal
		]
	
	# Ban specific attributes depending on weapon
	var piercing_ban = false
	if !weapon_stats.projectile_scene:
		piercing_ban = true
	elif weapon_stats.projectile_scene.instance().get_script().get_path().rfind("structure_spawner_projectile.gd") != -1:
		piercing_ban = true
	elif weapon_stats.projectile_scene.instance().get_script().get_path().rfind("boomerang_projectile.gd") != -1:
		piercing_ban = true
		
	var extra_projectiles_ban = false
	if !weapon_stats.projectile_scene:
		extra_projectiles_ban = true
		
	var bounce_ban = false
	if !weapon_stats.can_bounce:
		bounce_ban = true
		
	var range_ban = false
	if weapon_stats.projectile_scene:
		if weapon_stats.projectile_scene.instance().get_script().get_path().rfind("structure_spawner_projectile.gd") != -1:
			range_ban = true
		
	if !piercing_ban:
#		print("piercing not banned")
		stats_list.append(weapon_current_stats.piercing)
		
	if !extra_projectiles_ban: # TODO Rolling Cutter, Thunder Beam extra projectiles
#		print("projectiles not banned")
		stats_list.append(weapon_current_stats.nb_projectiles)
		
	if !bounce_ban: # TODO Thunder beam extra projectiles
#		print("bounce not banned")
		stats_list.append(weapon_current_stats.bounce)
		
	if !range_ban: 
#		print("range not banned")
		stats_list.append(weapon_current_stats.max_range)
	
#	var chosen_stat = stats_list.pick_random()	
#	match chosen_stat:
#		weapon_current_stats.bounce:
#			weapon_current_stats.bounce += 1
#			print("bounce ",weapon_current_stats.bounce)
#		weapon_current_stats.piercing:
#			weapon_current_stats.piercing += 1
#			print("piercing ",weapon_current_stats.piercing)
#		weapon_current_stats.nb_projectiles:
#			weapon_current_stats.nb_projectiles += 1
#			weapon_current_stats.projectile_spread = min(weapon_current_stats.projectile_spread + 0.15, 3.14)
#			weapon_current_stats.damage = max(weapon_current_stats.damage * 0.7, 1)
#			print("projectiles ",weapon_current_stats.nb_projectiles)
#			print("spread ",weapon_current_stats.projectile_spread)
#			print("damage", weapon_current_stats.damage)
#		weapon_current_stats.cooldown:
#			weapon_current_stats.cooldown = max(weapon_current_stats.cooldown * 0.9, WeaponService.MIN_COOLDOWN)
#			print("cooldown ",weapon_current_stats.cooldown)
#		weapon_current_stats.damage: # fire storm rotating, oil slider skate, super arm extra, thunder beam sideways, mega buster charged
#			weapon_current_stats.damage = max(weapon_current_stats.damage * 1.2, weapon_current_stats.damage + 1)
#			print("damage ",weapon_current_stats.damage)
#		weapon_current_stats.crit_chance: # fire storm rotating, oil slider skate, super arm extra, thunder beam sideways, mega buster charged
#			weapon_current_stats.crit_chance += 0.15
#			weapon_current_stats.crit_damage += 0.15
#			print("crit chance ",weapon_current_stats.crit_chance)
#			print("crit damage ",weapon_current_stats.crit_damage)
#		weapon_current_stats.max_range:
#			weapon_current_stats.max_range *= 1.1
#			print("range ",weapon_current_stats.max_range)
#		weapon_current_stats.lifesteal: # time slow, fire storm rotating, oil slider skate, super arm extra, thunder beam sideways, mega buster charged
#			weapon_current_stats.lifesteal = min(weapon_current_stats.lifesteal + 0.1, 1.0)
#			print("lifesteal ",weapon_current_stats.lifesteal)
#	print("+",last_added_amount,"  ",energy_tank.current_value,"/",energy_tank.capacity)


func _on_EnergyTank_tank_full(energy_tank) -> void:
	print("full")
