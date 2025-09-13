class_name ShieldFormSceneEffectBehavior
extends SceneEffectBehavior

export (PackedScene) var rotating_shield_scene
var shield_projectiles = []

signal projectile_shot(projectile)

func _ready() -> void :
	if should_check():
		var _err = _entity_spawner_ref.connect("players_spawned",self,"_on_EntitySpawner_players_spawned")


func should_check() -> bool:
	for player_index in RunData.get_player_count():
		if RunData.get_player_effect("shield_form", player_index).size() > 0:
			return true

	if RunData.existing_weapon_has_effect("shield_form"):
		return true

	return false

func _on_EntitySpawner_players_spawned(players: Array) -> void :
	for player in players:
		# Get all projectiles (not the empty slots)
		for weapon in player._weapons_container.get_children():
			if weapon.script:
				for effect in weapon.effects:
					if effect.key == "shield_form":
						var _err = weapon._shooting_behavior.connect("projectile_shot", self, "_on_projectile_shot", [effect, weapon.stats])


func _on_projectile_shot(projectile, rotating_effect, projectile_stats) -> void :
	# create a group for rotating projectiles and add them to a list
	if projectile.rotating:
		shield_projectiles.append(projectile)
	var group_name = projectile.get_name().split("ShieldProjectile")[0].trim_prefix("@")
	var all_group_nodes = get_tree().get_nodes_in_group(group_name)
	shield_projectiles.append_array(all_group_nodes)
	if rotating_effect.value > 0:
		if shield_projectiles.size() >= rotating_effect.value:
			var last_shot_weapon = shield_projectiles[shield_projectiles.size() - 1]._hitbox.from
			var proj_rotation = rand_range(last_shot_weapon.rotation - last_shot_weapon.current_stats.projectile_spread, last_shot_weapon.rotation + last_shot_weapon.current_stats.projectile_spread)
			var knockback_direction: = Vector2(cos(proj_rotation), sin(proj_rotation))
			var rotating_shield_projectile = shoot_projectile(last_shot_weapon, proj_rotation, knockback_direction)
			var player_projectiles = Utils.get_scene_node().get_node("PlayerProjectiles")
			var projectiles_container = rotating_shield_projectile.get_node("ProjectileContainer")
			for proj in shield_projectiles:
				player_projectiles.remove_child(proj)
				projectiles_container.add_child(proj)
				proj.velocity *= projectile_stats.projectile_speed / rotating_effect.rotating_speed
#				proj.rotating = false
				proj.around_player_only = false
			projectiles_container.update_projectiles_positions(shield_projectiles)
#			for proj in shield_projectiles:
#				proj.velocity *= projectile_stats.projectile_speed / rotating_effect.rotating_speed
#				proj.rotating = false
			shield_projectiles.clear()

#func _on_projectile_shot(projectile, rotating_effect, projectile_stats) -> void :
#	# create a group for rotating projectiles and add them to a list
#	if projectile.rotating:
#		shield_projectiles.append(projectile)
#	var group_name = projectile.get_name().split("ShieldProjectile")[0].trim_prefix("@")
#	var all_group_nodes = get_tree().get_nodes_in_group(group_name)
#	shield_projectiles.append_array(all_group_nodes)
#	if rotating_effect.value > 0:
#		if shield_projectiles.size() >= rotating_effect.value:
#			for proj in shield_projectiles:
#				proj.velocity *= projectile_stats.projectile_speed / rotating_effect.rotating_speed
#				proj.rotating = false
#			shield_projectiles.clear()

func shoot_projectile(weapon, rotation, knockback: Vector2 = Vector2.ZERO) -> Node:
	var args: = WeaponServiceSpawnProjectileArgs.new()
	args.knockback_direction = knockback
	args.effects = weapon.effects
	args.from_player_index = weapon.player_index
	
	weapon.current_stats.projectile_scene = rotating_shield_scene

	var projectile = WeaponService.spawn_projectile(
		weapon.muzzle.global_position, 
		weapon.current_stats, 
		weapon._shooting_behavior.rotation, 
		weapon, 
		args
	)
	
	weapon.current_stats.projectile_scene = weapon.stats.projectile_scene

	emit_signal("projectile_shot", projectile)
	return projectile
