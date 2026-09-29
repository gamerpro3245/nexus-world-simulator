class_name NexusOrderProcessor
extends RefCounted

func validate(order: NexusOrder, simulation: NexusGameSimulation) -> bool:
	if order == null:
		return false

	if order.province_id >= 0 and order.province_id >= simulation.country.provinces.size():
		return false

	return true
