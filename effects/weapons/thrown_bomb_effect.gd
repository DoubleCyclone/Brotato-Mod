class_name ThrownBombEffect
extends NullEffect

export (Array,Resource) var effects
export (PackedScene) var structure_scene
export (float) var timer_cooldown

static func get_id() -> String:
	return "effect_hyper_bomb_spawn"
	
func get_args(_player_index: int) -> Array:
	var scale
	for effect in effects:
		if effect.key == "effect_explode":
			if RunData.players_data[_player_index].effects["explosion_size"] != 0:				
				scale = effect.scale * (RunData.players_data[_player_index].effects["explosion_size"] / 100)
			else:
				scale = effect.scale
	return [str(timer_cooldown), str(scale)]
	
