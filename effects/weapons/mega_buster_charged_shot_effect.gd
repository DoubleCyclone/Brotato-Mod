class_name MegaBusterChargedShotEffect
extends EffectWithSubEffects

export (PackedScene) var charged_projectile
export (Array, AudioStream) var charged_shot_sounds

static func get_id() -> String:
	return "mega_buster_charged_shot_effect"
	
#func get_args(_player_index: int) -> Array:
#	var args = .get_args(_player_index)
#
#	for sub_effect in sub_effects:
#		args.append_array(sub_effect.get_args(_player_index))
#
#	return args
