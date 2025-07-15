class_name SuperArmConsumableDropEffect
extends NullEffect


func apply(_player_index: int) -> void:
	var consumables = []
	for consumable in ItemService.consumables:
		if consumable.my_id == "consumable_super_arm_stone":
			return
	consumables.append(load("res://mods-unpacked/8bithero-FirstModTrial/items/consumables/super_arm_stone/super_arm_stone_data.tres"))
	ItemService.consumables.append_array(consumables)
	
func unapply(_player_index: int) -> void:
	for consumable in ItemService.consumables:
		if consumable.my_id == "consumable_super_arm_stone":
			ItemService.consumables.erase(consumable)
			return
