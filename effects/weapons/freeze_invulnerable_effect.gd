class_name FreezeInvulnerableEffect
extends Effect

export(String) var source_id = ""
export (float, 0.0, 1.0, 0.01) var chance: = 1.0
export(int) var duration_secs = 1
export(int) var max_stacks = 1
export(Color) var outline_color = Color.white
export(Color) var effect_color = Color("aadae6")

static func get_id() -> String:
	return "weapon_freeze_invulnerable_effect"
	
func get_args(_player_index: int) -> Array:
	return [str(chance*100), str(duration_secs), str(chance*20)]

func apply(_player_index: int) -> void :
	pass

func unapply(_player_index: int) -> void :
	pass

func to_array() -> Array:
	return [source_id, key, value, chance, duration_secs, max_stacks, outline_color.to_html(), effect_color.to_html()]

func serialize() -> Dictionary:
	var serialized = .serialize()

	serialized.source_id = source_id
	serialized.chance = chance
	serialized.duration_secs = duration_secs
	serialized.max_stacks = max_stacks
	serialized.outline_color = outline_color.to_html()
	serialized.effect_color = effect_color.to_html()

	return serialized


func deserialize_and_merge(serialized: Dictionary) -> void:
	.deserialize_and_merge(serialized)

	source_id = serialized.source_id
	chance = serialized.chance
	duration_secs = serialized.duration_secs
	max_stacks = serialized.max_stacks
	outline_color = Color(serialized.outline_color)
	effect_color = Color(serialized.effect_color)
