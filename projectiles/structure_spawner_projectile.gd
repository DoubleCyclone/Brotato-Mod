class_name StructureSpawnerProjectile
extends PlayerProjectile

#onready var slow_hitbox: Area2D = $"%SlowHitbox"
export (PackedScene) var structure_scene
var _entity_spawner_ref

func _ready() -> void :
	._ready()
	_hitbox.connect("area_entered",self,"on_tree_exiting")
#	_entity_spawner_ref = Utils.get_scene_node().get_node("EntitySpawner")
#	var hyper_bomb_effect = RunData.get_player_effect("effect_hyper_bomb_spawn",player_index)
#	var structure_instance = structure_scene.instance()
#	structure_instance.position = position
#	add_child(structure_instance)
#	connect("ready",self,"on_tree_exiting")

func on_tree_exiting() -> void : 
	print("exiting")
