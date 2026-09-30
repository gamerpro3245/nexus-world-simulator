class_name NexusOrder
extends RefCounted

var text := ""
var type := "custom"
var target_province := -1
var cost := 0.0
var duration_months := 1

func _init(order_text: String = "") -> void:
	text = order_text
