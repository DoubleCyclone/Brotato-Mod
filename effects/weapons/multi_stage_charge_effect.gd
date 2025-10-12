class_name MultiStageChargeEffect
extends NullEffect

export (Array, PackedScene) var projectile_stages
export (Array, float) var damage_multipliers
export (Array, int) var extra_piercings


static func get_id() -> String:
	return "weapon_multi_stage_charge_effect"
	
	
func get_args(player_index: int) -> Array:
	return [str(projectile_stages.size()) ,get_array_contents_divided(damage_multipliers), get_array_contents_divided(extra_piercings)]


func get_array_contents_divided(list) -> String :
	var result = ""
	for item in list:
		if !(list.find(item) == list.size() - 1):
			result += str(item) 
			result += "/"
		else:
			result += str(item)
	return result
