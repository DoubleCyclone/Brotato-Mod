class_name HyperBombThrowStructureSceneEffectBehavior
extends SceneEffectBehavior

export (PackedScene) var structure_scene
export (Texture) var ready_sprite
var current_weapon
var current_effect
var current_player_index

func _ready() -> void :
	_entity_spawner_ref = Utils.get_scene_node().get_node("EntitySpawner")
	if should_check():
		print("shouldcheck")
		for player in RunData.players_data:
			for weapon in player.weapons:
				for effect in weapon.effects:
					if effect.key == "effect_hyper_bomb_spawn":
						current_effect = effect
						current_weapon = weapon
						current_player_index = RunData.players_data.find(player)
						_entity_spawner_ref.connect("enemy_spawned",self,"on_enemy_spawned")

func should_check() -> bool:
	if RunData.existing_weapon_has_effect("effect_hyper_bomb_spawn"):
		return true
	return false

func on_enemy_spawned(enemy:Enemy):
	enemy.connect("took_damage",self,"on_body_entered")

func on_body_entered(unit, value, knockback_direction, is_crit, is_dodge, is_protected, armor_did_something, args, hit_type):
	var instance = structure_scene.instance()
	instance.player_index = current_player_index
	instance.position = unit.position
	instance.stats = current_weapon.stats
	instance.effects = current_effect.effects
	Utils.get_scene_node().get_node("Entities").add_child(instance)
