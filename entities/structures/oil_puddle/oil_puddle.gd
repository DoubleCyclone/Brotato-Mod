class_name OilPuddle
extends Structure

export (Array, Resource) var pressed_sounds
export (PackedScene) var oil_skate

onready var _sprite = $Animation / Sprite
onready var _original_texture = _sprite.texture
var skate_instance
var spawn_effect
var from_weapon


func respawn() -> void :
	.respawn()
	_sprite.texture = _original_texture


func _on_Area2D_body_entered(_body: Node) -> void :
	if dead or not(_body is Player): return
	for effect in effects:
		if effect.key == "oil_slider_structure_spawn" and !_body.get_node("Animation/Sprite").has_node("OilSliderSkate"):
			spawn_effect = effect
			spawn_skate(_body)
			die()


func _on_Area2D_body_exited(_body: Node) -> void :
	pass
	
	
func spawn_skate(_body: Node) -> void:
	SoundManager2D.play(Utils.get_rand_element(pressed_sounds), global_position, 5, 0.2)
	skate_instance = oil_skate.instance()
	skate_instance.spawn_effect = spawn_effect
	skate_instance.from_weapon = from_weapon
	skate_instance.get_node("Sprite").scale = Vector2(3,3)
	_body.get_node("Animation/Sprite").call_deferred("add_child",skate_instance)

	
