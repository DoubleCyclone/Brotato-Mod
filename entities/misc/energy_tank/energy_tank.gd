class_name EnergyTank
extends Node

var capacity : float = 100.0
var current_value : float = 0.0
var start_value : float = 0.0

func _ready():
	print("energy_tank_ready")

func fill(amount: float):
	current_value+=min(amount/4, 10)
	if current_value >= capacity:
		current_value = capacity
	
func _physics_process(delta):
	if current_value >= capacity:
		print("FULL")
