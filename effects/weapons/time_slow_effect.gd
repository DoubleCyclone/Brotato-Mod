class_name TimeSlowEffect
extends Effect

export(String) var source_id = ""
export (float, 0.0, 1.0, 0.01) var chance: = 1.0
export (float, 0.0, 1.0, 0.01) var amount: = 1.0
export(int) var duration_secs = 4
export(int) var max_stacks = 2
export(Color) var outline_color = Color.white
export(Color) var effect_color = Color("b647ba")

static func get_id() -> String:
	return "weapon_time_slow_effect"
	
func get_args(_player_index: int) -> Array:
	return [str(chance * 100), str(amount * 100) ,str(duration_secs), str(amount * 100 * max_stacks)]

func apply(_player_index: int) -> void :
	pass

func unapply(_player_index: int) -> void :
	pass

func to_array() -> Array:
	return [source_id, key, value, chance, amount, duration_secs, max_stacks, outline_color.to_html(), effect_color.to_html()]

func serialize() -> Dictionary:
	var serialized = .serialize()

	serialized.source_id = source_id
	serialized.chance = chance
	serialized.amount = amount
	serialized.duration_secs = duration_secs
	serialized.max_stacks = max_stacks
	serialized.outline_color = outline_color.to_html()
	serialized.effect_color = effect_color.to_html()

	return serialized


func deserialize_and_merge(serialized: Dictionary) -> void:
	.deserialize_and_merge(serialized)

	source_id = serialized.source_id
	chance = serialized.chance
	amount = serialized.amount
	duration_secs = serialized.duration_secs
	max_stacks = serialized.max_stacks
	outline_color = Color(serialized.outline_color)
	effect_color = Color(serialized.effect_color)
