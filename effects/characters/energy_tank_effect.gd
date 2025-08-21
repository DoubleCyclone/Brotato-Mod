class_name EnergyTankEffect
extends Effect

export (PackedScene) var energy_tank_scene

static func get_id() -> String:
	return "energy_tank_effect"
	
func get_args(_player_index: int) -> Array:
	var energy_tank_instance = energy_tank_scene.instance()
	return [str(energy_tank_instance.capacity)]
