class_name OilSliderStructureSpawnSceneEffectBehavior
extends SceneEffectBehavior

func _ready() -> void :
	if should_check():
		var _err = _entity_spawner_ref.connect("enemy_spawned",self,"_on_EntitySpawner_enemy_spawned")

func should_check() -> bool:
	print("check oil slider")
	if RunData.existing_weapon_has_effect("oil_slider_structure_spawn"):
		return true
	return false

func _on_EntitySpawner_enemy_spawned(enemy: Enemy) -> void :
	enemy.connect("took_damage",self,"_on_enemy_took_damage")
	
func _on_enemy_took_damage(unit, value, knockback_direction, is_crit, is_dodge, is_protected, armor_did_something, args, hit_type) -> void :
	print("took damage oil slider")

	

	
