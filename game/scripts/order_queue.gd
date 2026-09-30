class_name OrderQueue
extends RefCounted

var pending: Array[NexusOrder] = []

func add(order: NexusOrder) -> void:
	pending.append(order)

func count() -> int:
	return pending.size()

func clear() -> void:
	pending.clear()
