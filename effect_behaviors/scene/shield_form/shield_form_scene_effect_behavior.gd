class_name ShieldFormSceneEffectBehavior
extends SceneEffectBehavior

export (PackedScene) var rotating_shield_scene
export (PackedScene) var projectile_shield_scene
var shield_projectiles = []
#var shield_projectiles_dict = {}
#var counter = 0

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
						var _err = weapon._shooting_behavior.connect("shield_forming_projectile_shot", self, "_on_projectile_shot", [effect, weapon, player])
						var weapon_name = weapon.get_name().lstrip("@")
						var parts = weapon_name.split("@")
						weapon_name = parts[0]
						if !_err and !player.has_node(weapon_name + "ProjectileShield"):
							var proj_shield = projectile_shield_scene.instance()
							proj_shield.set_name(weapon_name + "ProjectileShield")
							proj_shield.max_projectile_count = effect.value
							player.add_child(proj_shield)
#							shield_projectiles_dict[proj_shield.get_name()] = proj_shield.proj_array
	

func _on_projectile_shot(projectile, rotating_effect, weapon, player) -> void :
	var last_shot_weapon = projectile._hitbox.from
	var weapon_name = weapon.get_name().lstrip("@")
	var parts = weapon_name.split("@")
	weapon_name = parts[0]
	if rotating_effect.value > 0:
		var grouped_projectiles = player.get_node(weapon_name + "ProjectileShield").proj_array
		if grouped_projectiles.size() < rotating_effect.value:
			grouped_projectiles.append(projectile)
		if grouped_projectiles.size() >= rotating_effect.value:
			var proj_rotation = rand_range(last_shot_weapon.rotation - last_shot_weapon.current_stats.projectile_spread, last_shot_weapon.rotation + last_shot_weapon.current_stats.projectile_spread)
			var knockback_direction: = Vector2(cos(proj_rotation), sin(proj_rotation))
			var rotating_shield_projectile = shoot_projectile(last_shot_weapon, proj_rotation, knockback_direction)
			for proj in grouped_projectiles:
				proj.origin_object = rotating_shield_projectile
			grouped_projectiles.clear()
				
			

func shoot_projectile(weapon, rotation, knockback: Vector2 = Vector2.ZERO) -> Node:
	var args: = WeaponServiceSpawnProjectileArgs.new()
	args.knockback_direction = knockback
	args.effects = weapon.effects
	args.from_player_index = weapon.player_index
	
	weapon.current_stats.projectile_scene = rotating_shield_scene

	var projectile = WeaponService.spawn_projectile(
		weapon._parent.position, 
		weapon.current_stats, 
		rotation, 
		weapon, 
		args
	)


	emit_signal("projectile_shot", projectile)
	return projectile
