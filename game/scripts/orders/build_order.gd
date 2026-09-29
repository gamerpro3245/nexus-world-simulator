class_name NexusBuildOrder
extends NexusOrder

var building_type: String
var construction_months: int
var cost: float
var jobs_created: int
var production_bonus: float

func _init(target_province: int, type: String, months: int, build_cost: float, jobs: int, production: float) -> void:
	super("BUILD", target_province, 1)
	building_type = type
	construction_months = months
	cost = build_cost
	jobs_created = jobs
	production_bonus = production
