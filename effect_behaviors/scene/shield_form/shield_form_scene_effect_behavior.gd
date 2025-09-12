class_name ShieldFormSceneEffectBehavior
extends SceneEffectBehavior


var shield_projectiles = []


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
			for proj in shield_projectiles:
				proj.velocity *= projectile_stats.projectile_speed / rotating_effect.rotating_speed
				proj.rotating = false
			shield_projectiles.clear()
