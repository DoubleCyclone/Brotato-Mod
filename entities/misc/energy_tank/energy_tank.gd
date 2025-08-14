class_name EnergyTank
extends Node

var capacity : float = 100.0
var current_value : float = 0.0
var start_value : float = 0.0
var weapon

signal tank_filled(tank, amount)
signal tank_full(tank)

func _ready():
	weapon = get_parent()


func fill(amount: float):
	var fill_amount = min(amount/4, 10)
	current_value += fill_amount
	emit_signal("tank_filled", self, fill_amount)
	if current_value >= capacity:
		current_value = capacity
		emit_signal("tank_full", self)
		
	
	
#func _physics_process(delta):
#	if current_value >= capacity:
#		print("FULL")

