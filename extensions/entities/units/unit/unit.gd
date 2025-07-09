extends "res://entities/units/unit/unit.gd"

func _on_Hurtbox_area_entered(hitbox: Area2D) -> void :	
	if not hitbox.active or hitbox.ignored_objects.has(self):
		return
	var dmg = hitbox.damage
	var dmg_taken = [0, 0]
	var from = hitbox.from if is_instance_valid(hitbox.from) else null
	var from_player_index = from.player_index if (from != null and "player_index" in from) else RunData.DUMMY_PLAYER_INDEX

	if hitbox.deals_damage:
		
		for effect_behavior in effect_behaviors.get_children():
			effect_behavior.on_hurt(hitbox)
		_on_hurt(hitbox)

		var is_exploding = false
		for effect in hitbox.effects:
			if effect is ExplodingEffect:
				if Utils.get_chance_success(effect.chance):
					var args: = WeaponServiceExplodeArgs.new()
					args.pos = global_position
					args.damage = hitbox.damage
					args.accuracy = hitbox.accuracy
					args.crit_chance = hitbox.crit_chance
					args.crit_damage = hitbox.crit_damage
					args.burning_data = hitbox.burning_data
					args.scaling_stats = hitbox.scaling_stats
					args.from_player_index = from_player_index
					args.is_healing = hitbox.is_healing
					args.damage_tracking_key = hitbox.damage_tracking_key

					var explosion = WeaponService.explode(effect, args)
					if from != null and from.has_method("on_weapon_hit_something"):
						explosion.connect("hit_something", from, "on_weapon_hit_something", [explosion._hitbox])

					is_exploding = true
			elif effect is PlayerHealthStatEffect and effect.key == "stat_damage":
				dmg += effect.get_bonus_damage(from_player_index)
			elif effect is FreezeInvulnerableEffect : # Freeze the enemy and make it invulnerable	
				get_node("Collision").set_deferred("disabled",true)	# make enemy not block others
				get_node("Hitbox").set_deferred("deals_damage",false) # make the enemy deal no damage
				get_node("AnimationPlayer").current_animation = "[stop]" # freeze the animation
				_hurtbox.disable() # to make invulnerable
				current_stats.speed = 0 # in case we need to process speed
				# TODO : make enemy sprite not turn, flash blue in this state, add a timer for the effect, add chance

		
		if not is_exploding:
			var args: = TakeDamageArgs.new(from_player_index, hitbox)
			dmg_taken = take_damage(dmg, args)
			if hitbox.burning_data != null and Utils.get_chance_success(hitbox.burning_data.chance) and not hitbox.is_healing and RunData.get_player_effect("can_burn_enemies", from_player_index) > 0:
				apply_burning(hitbox.burning_data)

		if hitbox.projectiles_on_hit.size() > 0:
			for i in hitbox.projectiles_on_hit[0]:
				var weapon_stats: RangedWeaponStats = hitbox.projectiles_on_hit[1]
				var auto_target_enemy: bool = hitbox.projectiles_on_hit[2]
				var args = WeaponServiceSpawnProjectileArgs.new()
				args.from_player_index = from_player_index
				var projectile = WeaponService.manage_special_spawn_projectile(
					self, 
					weapon_stats, 
					rand_range( - PI, PI), 
					auto_target_enemy, 
					_entity_spawner_ref, 
					from, 
					args
				)
				if from != null and from.has_method("on_weapon_hit_something") and not projectile.is_connected("hit_something", from, "on_weapon_hit_something"):
					projectile.connect("hit_something", from, "on_weapon_hit_something", [projectile._hitbox])

				projectile.call_deferred("set_ignored_objects", [self])

		if hitbox.speed_percent_modifier != 0:
			add_decaying_speed((get_base_speed_value_for_pct_based_decrease() * hitbox.speed_percent_modifier / 100.0) as int)

	hitbox.hit_something(self, dmg_taken[1])
