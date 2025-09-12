class_name ShieldFormSceneEffectBehavior
extends SceneEffectBehavior


func _ready() -> void :
	if should_check():
		var _err = _entity_spawner_ref.connect("players_spawned",self,"_on_EntitySpawner_players_spawned")


func should_check() -> bool:
	if RunData.existing_weapon_has_effect("shield_form"):
		return true
	for player_index in RunData.get_player_count():
		if RunData.get_player_effect("shield_form", player_index).size()  > 0:
			return true
	return false

func _on_EntitySpawner_players_spawned(players: Array) -> void :
	for player in players:
		# Get all weapons (not the empty slots)
		for weapon in player._weapons_container.get_children():
			if weapon.script:
				for effect in weapon.effects:
					if effect.key == "shield_form":
						var _err = weapon._shooting_behavior.connect("projectile_shot", self, "_on_projectile_shot", [effect, weapon.stats])

func _on_projectile_shot(projectile, rotating_effect, weapon_stats) -> void :
	# create a group for rotating projectiles and add them to a list
	var group_name = projectile.get_name().split("ShieldProjectile")[0].trim_prefix("@")
	if projectile.rotating:
		projectile.add_to_group(group_name)
	var all_group_nodes = get_tree().get_nodes_in_group(group_name)
	print(all_group_nodes.size())
	# form the shield? or throw projectiles
	if rotating_effect.value > 0:
		if all_group_nodes.size() >= rotating_effect.value:
			for projectile in all_group_nodes:
				projectile.velocity *= weapon_stats.projectile_speed / rotating_effect.rotating_speed
				projectile.rotating = false
#				projectile.connect("hitbox_disabled",self,"_on_hitbox_disabled")
			all_group_nodes.clear()
