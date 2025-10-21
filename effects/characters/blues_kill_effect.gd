class_name BluesKillEffect
extends Effect

export (float, 0.0, 1.0, 0.01) var chance: = 0.03

static func get_id() -> String:
	return "blues_kill_effect"
	
func apply(player_index: int) -> void:
	var effects = RunData.get_player_effects(player_index)
	effects["blues_shield_gain_on_kill"] = chance

func unapply(player_index: int) -> void:
	var effects = RunData.get_player_effects(player_index)
	effects["blues_shield_gain_on_kill"] = 0
	
func get_args(_player_index: int) -> Array:
	return [str(chance * 100)]
