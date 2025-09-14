class_name ShieldFormSceneEffectBehavior
extends SceneEffectBehavior

export (PackedScene) var rotating_shield_scene
var shield_projectiles = []
var counter = 0

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
						var _err = weapon._shooting_behavior.connect("shield_forming_projectile_shot", self, "_on_projectile_shot", [effect, weapon.stats])


func _on_projectile_shot(projectile, rotating_effect, projectile_stats) -> void :
	shield_projectiles.append(projectile)
	if rotating_effect.value > 0:
		if shield_projectiles.size() >= rotating_effect.value:
			var last_shot_weapon = projectile._hitbox.from
			var proj_rotation = rand_range(last_shot_weapon.rotation - last_shot_weapon.current_stats.projectile_spread, last_shot_weapon.rotation + last_shot_weapon.current_stats.projectile_spread)
			var knockback_direction: = Vector2(cos(proj_rotation), sin(proj_rotation))
			var rotating_shield_projectile = shoot_projectile(last_shot_weapon, proj_rotation, knockback_direction)
			for proj in shield_projectiles:
				proj.origin_object = rotating_shield_projectile
			shield_projectiles.clear()
			

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
	
#	weapon.current_stats.projectile_scene = weapon.stats.projectile_scene

#	emit_signal("projectile_shot", projectile)
	return projectile
