class_name NexusResource
extends RefCounted

var resource_name: String
var amount: float = 0.0
var production_per_month: float = 0.0
var consumption_per_month: float = 0.0
var price: float = 1.0

func _init(name: String, initial_amount: float, production: float, consumption: float, unit_price: float) -> void:
	resource_name = name
	amount = initial_amount
	production_per_month = production
	consumption_per_month = consumption
	price = unit_price

func simulate_month() -> void:
	amount = maxf(0.0, amount + production_per_month - consumption_per_month)

func to_dict() -> Dictionary:
	return {
		"name": resource_name,
		"amount": amount,
		"production": production_per_month,
		"consumption": consumption_per_month,
		"price": price
	}
