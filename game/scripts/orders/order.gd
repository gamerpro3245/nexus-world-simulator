class_name NexusOrder
extends RefCounted

var order_type: String
var province_id: int = -1
var quantity: int = 0

func _init(type: String, target_province: int = -1, amount: int = 0) -> void:
	order_type = type
	province_id = target_province
	quantity = amount
