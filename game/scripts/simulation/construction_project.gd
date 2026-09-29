class_name NexusConstructionProject
extends RefCounted

var province_id: int
var building_type: String
var months_left: int
var cost: float
var jobs_created: int
var production_bonus: float

func _init(target_province: int, type: String, months: int, build_cost: float, jobs: int, production: float) -> void:
	province_id = target_province
	building_type = type
	months_left = months
	cost = build_cost
	jobs_created = jobs
	production_bonus = production

func advance_month() -> bool:
	months_left -= 1
	return months_left <= 0

func to_dict() -> Dictionary:
	return {
		"province_id": province_id,
		"building_type": building_type,
		"months_left": months_left,
		"cost": cost,
		"jobs_created": jobs_created,
		"production_bonus": production_bonus
	}
