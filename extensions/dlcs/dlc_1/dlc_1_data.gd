extends "res://dlcs/dlc_1/dlc_1_data.gd"

func curse_item(item_data: ItemParentData, player_index: int, turn_randomization_off: bool = false, min_modifier: float = 0.0) -> ItemParentData:
	if item_data.is_cursed:
		return item_data

	var new_effects: = []
	var max_effect_modifier = 0.0
	var curse_effect_modified: = false
	var new_item_data = item_data.duplicate()

	if item_data is WeaponData:
		var effect_modifier: = _get_cursed_item_effect_modifier(turn_randomization_off, min_modifier)
		max_effect_modifier = max(max_effect_modifier, effect_modifier)
		new_item_data.stats = _boost_weapon_stats_damage(item_data.stats, effect_modifier)

	for effect in item_data.effects:
		var effect_modifier: = _get_cursed_item_effect_modifier(turn_randomization_off, min_modifier)
		max_effect_modifier = max(max_effect_modifier, effect_modifier)

		var new_effect = effect.duplicate()

		if effect is StructureEffect:
			new_effect.is_cursed = true
			if effect.key == "wandering_bot":
				
				assert (item_data.my_id == "item_wandering_bot", "expected item_wandering_bot (got %s)" % item_data.my_id)
				var extra_effect = Effect.new()
				extra_effect.key = "stat_speed"
				extra_effect.value = int(ceil(wandering_bot_speed * (1.0 + effect_modifier)))
				new_effects.append(extra_effect)
			elif effect.spawn_cooldown > 0:
				
				new_effect.spawn_cooldown = WeaponService.apply_attack_speed_mod_to_cooldown(effect.spawn_cooldown, effect_modifier)
			elif not effect.stats.scaling_stats.empty():
				
				new_effect.stats = _boost_weapon_stats_damage(effect.stats, effect_modifier)
			elif effect.effects.size() >= 1 and effect.effects[0] is BurningEffect:
				
				var new_burning_effect = effect.effects[0].duplicate()
				var new_burning_data = new_burning_effect.burning_data.duplicate()
				new_burning_data.scaling_stats = _boost_scaling_sats(new_burning_data.scaling_stats, effect_modifier)
				new_burning_effect.burning_data = new_burning_data
				new_effect.effects[0] = new_burning_effect
			else:
				
				var stats = effect.stats.duplicate()
				
				stats.cooldown = WeaponService.apply_attack_speed_mod_to_cooldown(stats.cooldown / Utils.TICKS_PER_SECOND, effect_modifier) * Utils.TICKS_PER_SECOND
				new_effect.stats = stats
		elif effect is BurnChanceEffect:
			
			var burning_data = effect.burning_data.duplicate()
			burning_data.duration = int(ceil(burning_data.duration * (1.0 + effect_modifier)))
			burning_data.damage = int(ceil(burning_data.damage * (1.0 + effect_modifier)))
			new_effect.burning_data = burning_data
		elif effect is BurningEffect:
			
			var burning_data = effect.burning_data.duplicate()
			burning_data.duration = int(ceil(burning_data.duration * (1.0 + effect_modifier)))
			burning_data.damage = int(ceil(burning_data.damage * (1.0 + effect_modifier)))
			new_effect.burning_data = burning_data
		elif effect is ItemExplodingEffect:
			if effect.scale_with_missing_health:
				new_effect.value = _boost_effect_value_positively(effect, effect_modifier)
			else:
				new_effect.stats = _boost_weapon_stats_damage(effect.stats, effect_modifier)
		elif item_data is WeaponData and effect is ExplodingEffect and effect.chance < 1.0:
			new_effect.chance = min(1.0, new_effect.chance * (1.0 + effect_modifier / 5.0))

			if new_effect.chance >= 1.0:
				new_effect.text_key = "effect_explode"

		elif effect is ProjectileEffect or effect is ProjectilesOnHitEffect:
			new_effect.weapon_stats = _boost_weapon_stats_damage(effect.weapon_stats, effect_modifier)
		elif effect is GainStatEveryKilledEnemiesEffect:
			new_effect.value = _boost_effect_value_positively(new_effect, effect_modifier, true, Sign.NEGATIVE)
		elif effect is SwapMaxMinStatEffect:
			var min_max_stat_values = effect._find_min_max_stat_keys(player_index)

			var extra_effect = Effect.new()
			extra_effect.key = min_max_stat_values[1]
			extra_effect.value = axolotl_stats
			extra_effect.effect_sign = Sign.POSITIVE
			extra_effect.value = _boost_effect_value_positively(extra_effect, effect_modifier)
			new_effects.append(extra_effect)

			var extra_effect_2 = extra_effect.duplicate()
			extra_effect_2.key = min_max_stat_values[0]
			new_effects.append(extra_effect_2)

		elif effect.custom_key == "gain_stat_for_every_step_after_equip":
			new_effect.value2 = _boost_effect_value_positively(new_effect, effect_modifier, true, Sign.NEGATIVE, true)
		elif effect.key == "break_on_hit":
			new_effect.value2 = _boost_effect_value_positively(new_effect, effect_modifier, false, Sign.POSITIVE, true)
		elif effect.key == "hp_start_next_wave":
			new_effect.value = - 100
		elif effect.key == "item_mirror":
			new_effects.append(effect)
			var extra_effect = Effect.new()
			extra_effect.key = "items_price"
			extra_effect.value = mirror_item_price
			extra_effect.effect_sign = Sign.POSITIVE
			extra_effect.value = _boost_effect_value_positively(extra_effect, effect_modifier)
			new_effects.append(extra_effect)
			var extra_tooltip_effect = Effect.new()
			extra_tooltip_effect.text_key = "EFFECT_CURSED_MIRROR"
			new_effects.append(extra_tooltip_effect)
			continue
		elif effect.key == "hit_protection":
			assert (item_data.my_id == "item_tardigrade", "expected item_tardigrade (got %s)" % item_data.my_id)
			new_effect.value = 2
			new_effect.text_key = "effect_hit_protection_plural"
		elif effect.key == "one_shot_trees" or effect.key == "tree_turrets":
			
			var extra_effect = Effect.new()
			extra_effect.key = "trees"
			extra_effect.text_key = "effect_trees"
			extra_effect.value = 1
			new_effects.append(extra_effect)
		elif effect.key == "instant_gold_attracting" and effect.value == 100:
			assert (item_data.my_id == "item_sifds_relic", "expected item_sifds_relic (got %s)" % item_data.my_id)
			var extra_effect = Effect.new()
			extra_effect.key = "stat_dodge"
			extra_effect.value = int(ceil(sifds_relic_dodge * (1.0 + effect_modifier)))
			new_effects.append(extra_effect)
		elif effect.key == "hp_regen_bonus":
			
			assert (item_data.my_id == "item_potion", "expected item_potion (got %s)" % item_data.my_id)
			new_effect.value2 = min(90.0, _boost_effect_value_positively(effect, effect_modifier, false, Sign.POSITIVE, true))
		else:
			var override = false
			var overriden_sign = Sign.POSITIVE

			if effect.key == "consumable_heal_over_time":
				override = true
				overriden_sign = Sign.NEUTRAL
				var extra_effect = Effect.new()
				extra_effect.key = "stat_hp_regeneration"
				extra_effect.value = int(ceil(jerky_hp_regen * (1.0 + effect_modifier)))
				new_effects.append(extra_effect)
			elif effect.key == "knockback_aura":
				override = true
				overriden_sign = Sign.NEGATIVE
			elif effect.key == "modify_every_x_projectile":
				override = true
				overriden_sign = Sign.NEGATIVE
			elif item_data.my_id == "item_estys_couch" and effect.key == "stat_speed":
				override = true
				overriden_sign = Sign.POSITIVE
			elif "weapon_mace" in item_data.my_id and effect.key == "stat_attack_speed":
				override = true
				overriden_sign = Sign.POSITIVE
			elif ((item_data.my_id == "item_baby_gecko" and effect.key == "stat_range") or 
				(item_data.my_id == "item_potion" and effect.key == "stat_hp_regeneration") or 
				item_data.my_id == "item_pile_of_books" or item_data.my_id == "item_pocket_factory"):
				effect_modifier *= increase_factor_for_mediocre_boosts
			elif new_effect.custom_key == "upgrade_random_weapon":
				
				assert (item_data.my_id == "item_anvil", "expected item_anvil (got %s)" % item_data.my_id)
				var extra_effect = Effect.new()
				extra_effect.key = "stat_armor"
				extra_effect.value = int(ceil(anvil_armor * (1.0 + effect_modifier)))
				new_effects.append(extra_effect)
			elif effect.custom_key == "extra_item_in_crate" and effect.key == "random":
				var extra_effect = Effect.new()
				extra_effect.key = "stat_luck"
				extra_effect.value = treasure_map_luck
				extra_effect.effect_sign = Sign.POSITIVE
				extra_effect.value = _boost_effect_value_positively(extra_effect, effect_modifier)
				new_effects.append(extra_effect)
			
			# MOD SECTION START
			elif effect.key == "radial_explosion":
				new_effect.scale = _boost_effect_specific_value(effect.scale, true, effect_modifier)
			elif effect.custom_key == "effect_weapon_time_slow":
				new_effect.chance = min(_boost_effect_specific_value(effect.chance, true, effect_modifier), 1)
				new_effect.amount = min(_boost_effect_specific_value(effect.amount, true, effect_modifier), 1)
			# MOD SECTION END
			
			new_effect.value = _boost_effect_value_positively(effect, effect_modifier, override, overriden_sign)

			if new_effect.custom_key == "consumable_stats_while_max":
				new_effect.value2 = _boost_effect_value_positively(effect, effect_modifier, override, overriden_sign, true)
			elif new_effect.key == "remove_speed":
				new_effect.value2 = new_effect.value * 4
			elif (new_effect.key == "burning_enemy_hp_percent_damage"
				or new_effect.key == "giant_crit_damage"
				or new_effect.key == "bonus_current_health_damage"):
				new_effect.value2 = new_effect.value / 10.0
			elif new_effect.key == "gold_on_crit_kill":
				new_effect.value = min(new_effect.value, 100) as int
				if item_data.my_id == "item_hunting_trophy":
					var extra_effect = Effect.new()
					extra_effect.key = "stat_crit_chance"
					extra_effect.value = int(ceil(hunting_trophy_crit_chance * (1.0 + effect_modifier)))
					new_effects.append(extra_effect)


			if effect.key == "stat_curse":
				curse_effect_modified = true

		
		if effect.custom_key == "increase_tier_on_reroll":
			new_effect.text_key = "effect_increase_tier_on_reroll_plural"
		elif effect.key == "modify_every_x_projectile":
			if effect is WeaponEffectWithSubEffects:
				
				new_effect.value = max(1, effect.value - 1)
				if new_effect.value == 1:
					new_effect.text_key = "effect_weapon_modify_every_x_projectile_first"
				elif new_effect.value == 2:
					new_effect.text_key = "effect_weapon_modify_every_x_projectile_second"
				elif new_effect.value == 3:
					new_effect.text_key = "effect_weapon_modify_every_x_projectile_third"
			elif effect is EffectWithSubEffects:
				if new_effect.value == 1:
					new_effect.text_key = "effect_modify_every_x_projectile_first"
				elif new_effect.value == 2:
					new_effect.text_key = "effect_modify_every_x_projectile_second"
				elif new_effect.value == 3:
					new_effect.text_key = "effect_modify_every_x_projectile_third"
		elif effect.key == "bounce":
			new_effect.text_key = "effect_bouncing_plural"
		elif effect.key == "piercing":
			new_effect.text_key = "effect_piercing_plural"
		elif effect.key == "free_rerolls":
			new_effect.text_key = "effect_free_shop_reroll_plural"
		elif effect.key == "gold_on_cursed_enemy_kill":
			new_effect.text_key = "effect_gold_on_cursed_enemy_kill_plural"
		elif effect.key == "burning_spread":
			new_effect.text_key = "effect_burning_spread_plural"
		elif effect.key == "trees":
			new_effect.text_key = "effect_trees_plural"
		elif effect.key == "knockback_aura" and new_effect.value <= 1:
			new_effect.text_key = "effect_knockback_aura"

		new_effects.append(new_effect)

	if not curse_effect_modified:
		var curse_effect = Effect.new()
		curse_effect.key = "stat_curse"
		curse_effect.value = round(max(1.0, curse_per_item_value * item_data.value * (1.0 + max_effect_modifier))) as int
		curse_effect.effect_sign = Sign.OVERRIDE
		new_effects.append(curse_effect)

	new_item_data.effects = new_effects
	new_item_data.is_cursed = true

	new_item_data.curse_factor = max_effect_modifier

	return new_item_data as ItemParentData

func _boost_effect_specific_value(value, is_effect_good, effect_modifier: float) -> float:
	if is_effect_good:
		return value  * (1.0 + effect_modifier)
	else:
		return value  / (1.0 + effect_modifier)
