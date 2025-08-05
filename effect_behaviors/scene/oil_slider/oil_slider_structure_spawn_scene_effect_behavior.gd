class_name OilSliderStructureSpawnSceneEffectBehavior
extends SceneEffectBehavior

func _ready() -> void :
	if should_check():
		var _err = _entity_spawner_ref.connect("enemy_spawned",self,"_on_EntitySpawner_enemy_spawned")

func should_check() -> bool:
	if RunData.existing_weapon_has_effect("oil_slider_structure_spawn"):
		return true
	return false

func _on_EntitySpawner_enemy_spawned(enemy: Enemy) -> void :
	enemy.connect("took_damage",self,"_on_enemy_took_damage")
	
func _on_enemy_took_damage(unit, value, knockback_direction, is_crit, is_dodge, is_protected, armor_did_something, args, hit_type) -> void :
	var structure
	var chance = 0
	if args.hitbox:
		for effect in args.hitbox.effects:
			if effect.key == "oil_slider_structure_spawn":
				structure = effect.structure_scene
				chance = effect.chance
		if Utils.get_chance_success(chance):
			spawn_structure(structure, args.hitbox, unit)
		
func spawn_structure(structure_scene, hitbox, unit):
	var instance = structure_scene.instance()
	instance.player_index = hitbox.from.player_index
	instance.position = unit.position
#	instance.get_node("Animation/Sprite").scale = Vector2(2,2)
	instance.effects = hitbox.effects
	Utils.get_scene_node().get_node("Entities").call_deferred("add_child",instance)

	
