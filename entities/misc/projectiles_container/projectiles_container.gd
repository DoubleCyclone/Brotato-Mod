class_name ProjectilesContainer
extends Node2D


onready var _one_projectile_attachment_1 = $One / Attach1

onready var _two_projectiles_attachment_1 = $Two / Attach1
onready var _two_projectiles_attachment_2 = $Two / Attach2

onready var _three_projectiles_attachment_1 = $Three / Attach1
onready var _three_projectiles_attachment_2 = $Three / Attach2
onready var _three_projectiles_attachment_3 = $Three / Attach3

onready var _four_projectiles_attachment_1 = $Four / Attach1
onready var _four_projectiles_attachment_2 = $Four / Attach2
onready var _four_projectiles_attachment_3 = $Four / Attach3
onready var _four_projectiles_attachment_4 = $Four / Attach4

onready var _five_projectiles_attachment_1 = $Five / Attach1
onready var _five_projectiles_attachment_2 = $Five / Attach2
onready var _five_projectiles_attachment_3 = $Five / Attach3
onready var _five_projectiles_attachment_4 = $Five / Attach4
onready var _five_projectiles_attachment_5 = $Five / Attach5

onready var _six_projectiles_attachment_1 = $Six / Attach1
onready var _six_projectiles_attachment_2 = $Six / Attach2
onready var _six_projectiles_attachment_3 = $Six / Attach3
onready var _six_projectiles_attachment_4 = $Six / Attach4
onready var _six_projectiles_attachment_5 = $Six / Attach5
onready var _six_projectiles_attachment_6 = $Six / Attach6


func update_projectiles_positions(projectiles: Array) -> void :
	if projectiles.size() == 1:
		projectiles[0].attach(_one_projectile_attachment_1.position, 0)
	elif projectiles.size() == 2:
		projectiles[0].attach(_two_projectiles_attachment_1.position, 0)
		projectiles[1].attach(_two_projectiles_attachment_2.position, 0)
	elif projectiles.size() == 3:
		projectiles[0].attach(_three_projectiles_attachment_1.position, 0)
		projectiles[1].attach(_three_projectiles_attachment_2.position, 0)
		projectiles[2].attach(_three_projectiles_attachment_3.position, 0)
	elif projectiles.size() == 4:
		projectiles[0].attach(_four_projectiles_attachment_1.position, 0)
		projectiles[1].attach(_four_projectiles_attachment_2.position, 0)
		projectiles[2].attach(_four_projectiles_attachment_3.position, 0)
		projectiles[3].attach(_four_projectiles_attachment_4.position, 0)
	elif projectiles.size() == 5:
		projectiles[0].attach(_five_projectiles_attachment_1.position, 0)
		projectiles[1].attach(_five_projectiles_attachment_2.position, 0)
		projectiles[2].attach(_five_projectiles_attachment_3.position, 0)
		projectiles[3].attach(_five_projectiles_attachment_4.position, 0)
		projectiles[4].attach(_five_projectiles_attachment_5.position, 0)
	elif projectiles.size() == 6:
		projectiles[0].attach(_six_projectiles_attachment_1.position, 0)
		projectiles[1].attach(_six_projectiles_attachment_2.position, 0)
		projectiles[2].attach(_six_projectiles_attachment_3.position, 0)
		projectiles[3].attach(_six_projectiles_attachment_4.position, 0)
		projectiles[4].attach(_six_projectiles_attachment_5.position, 0)
		projectiles[5].attach(_six_projectiles_attachment_6.position, 0)
	else:
		for i in projectiles.size():
			var r = 60 + (projectiles.size() - 6) * 5
			var angle = i * ((2 * PI) / projectiles.size())

			projectiles[i].attach(Vector2(r * cos(angle), r * sin(angle)), 0)
