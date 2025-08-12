extends "res://ui/menus/shop/shop_items_container.gd"

func _can_weapon_be_bought(shop_item: ShopItem) -> bool:
	var min_weapon_tier = RunData.get_player_effect("min_weapon_tier", player_index)
	var max_weapon_tier = RunData.get_player_effect("max_weapon_tier", player_index)
	var no_melee_weapons = RunData.get_player_effect_bool("no_melee_weapons", player_index)
	var no_ranged_weapons = RunData.get_player_effect_bool("no_ranged_weapons", player_index)
	var no_duplicate_weapons = RunData.get_player_effect_bool("no_duplicate_weapons", player_index)
	var lock_current_weapons = RunData.get_player_effect_bool("lock_current_weapons", player_index)

	var limited_weapon_pool: bool = RunData.get_player_effect("limited_weapon_pool", player_index).size() > 0

	var weapon_data: WeaponData = shop_item.item_data
	var weapon_type: = weapon_data.type
	var weapons = RunData.get_player_weapons(player_index)
	var weapon_slot_available: bool = RunData.has_weapon_slot_available(weapon_data, player_index)

	var player_has_weapon = false
	for weapon in weapons:
		if weapon.my_id == weapon_data.my_id:
			player_has_weapon = true
			break

	var player_has_weapon_family = false
	if weapon_data.weapon_id in RunData.get_unique_weapon_ids(player_index):
		player_has_weapon_family = true

	if weapon_data.tier > max_weapon_tier or weapon_data.tier < min_weapon_tier:
		return false

	if no_melee_weapons and weapon_type == WeaponType.MELEE:
		return false

	if no_ranged_weapons and weapon_type == WeaponType.RANGED:
		return false

	if lock_current_weapons and not weapon_slot_available:
		return false
		
	if limited_weapon_pool:
		var permitted_sets_ids = []
		var current_weapon_sets = []
		for item_set in weapon_data.sets:
			current_weapon_sets.append(item_set.my_id)
		for set_data in RunData.get_player_effect("limited_weapon_pool", player_index):
			permitted_sets_ids.append(set_data.my_id)
		var matching_set = 0
		for set_id in permitted_sets_ids:	
			if current_weapon_sets.has(set_id):
				matching_set += 1
		if matching_set <= 0:
			return false
	
	if player_has_weapon and not weapon_slot_available and weapon_data.upgrades_into != null and weapon_data.upgrades_into.tier <= max_weapon_tier:
		return true

	if no_duplicate_weapons and player_has_weapon_family:
		return false

	return weapon_slot_available
