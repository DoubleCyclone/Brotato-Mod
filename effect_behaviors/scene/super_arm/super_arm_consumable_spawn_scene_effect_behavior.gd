class_name SuperArmConsumableSpawnSceneEffectBehavior
extends SceneEffectBehavior

export (Resource) var super_arm_stone
export (Texture) var ready_sprite
var drop_chance = 0

func _ready() -> void :
	if should_check():
		var _err = _entity_spawner_ref.connect("enemy_spawned",self,"_on_EntitySpawner_enemy_spawned")

func should_check() -> bool:
	if RunData.existing_weapon_has_effect("reload_when_pickup_super_arm_stone"):
		var highest_tier = Weapon.new()
		for player in RunData.players_data:
			for weapon in player.weapons:
				for effect in weapon.effects:
					if effect.key == "reload_when_pickup_super_arm_stone":
						highest_tier = weapon if weapon.tier >= highest_tier.tier else highest_tier
		for effect in highest_tier.effects:
			if effect.key == "reload_when_pickup_super_arm_stone":
				drop_chance = effect.consumable_drop_chance
		return true
	return false

func _on_EntitySpawner_enemy_spawned(enemy: Enemy) -> void :
	enemy.connect("died",self,"_on_Enemy_died")
	
func _on_Enemy_died(enemy: Node2D, _args: Entity.DieArgs) -> void :
	if Utils.get_chance_success(drop_chance):
		spawn_consumable(super_arm_stone, enemy.global_position)

func spawn_consumable(super_arm_stone_data, enemy_pos:Vector2) -> void:
	var main = Utils.get_scene_node()
	var consumable = main.consumable_scene.instance()
	main._consumables_container.call_deferred("add_child", consumable)
	var _error = consumable.connect("picked_up", self, "on_consumable_picked_up")
	yield(consumable, "ready")
			
	consumable.consumable_data = super_arm_stone_data
	consumable.set_texture(super_arm_stone_data.icon)
	var pos: = enemy_pos
	var dist: = rand_range(50, 100)
	var push_back_destination: Vector2 = ZoneService.get_rand_pos_in_area(pos, dist, 0)
	consumable.drop(pos, 0, push_back_destination)
	main._consumables.push_back(consumable)
	
	
func on_consumable_picked_up(item, player_index) -> void:
	var main = Utils.get_scene_node()
	var highest_cd_weapon_that_should_reload = null
	
	for weapon in main._players[player_index].current_weapons:
		for effect in weapon.effects:
			if effect.key == "reload_when_pickup_super_arm_stone":
				if not weapon._is_shooting and (highest_cd_weapon_that_should_reload == null or weapon._current_cooldown > highest_cd_weapon_that_should_reload._current_cooldown):
					highest_cd_weapon_that_should_reload = weapon
					
	if highest_cd_weapon_that_should_reload:
		highest_cd_weapon_that_should_reload.get_node("Sprite").texture = ready_sprite
		highest_cd_weapon_that_should_reload._current_cooldown = 0
		
	
