class_name NexusOrderProcessor
extends RefCounted

func validate(order: NexusOrder, simulation: NexusGameSimulation) -> bool:
	if order == null:
		return false
	if order.province_id < 0 or order.province_id >= simulation.country.provinces.size():
		return false
	if order is NexusBuildOrder:
		return _validate_build(order, simulation)
	return false

func execute(order: NexusOrder, simulation: NexusGameSimulation) -> bool:
	if not validate(order, simulation):
		return false
	if order is NexusBuildOrder:
		var build := order as NexusBuildOrder
		var project := NexusConstructionProject.new(build.province_id, build.building_type, build.construction_months, build.cost, build.jobs_created, build.production_bonus)
		simulation.construction_projects.append(project)
		simulation.country.treasury -= build.cost
		return true
	return false

func _validate_build(order: NexusBuildOrder, simulation: NexusGameSimulation) -> bool:
	if order.construction_months <= 0 or order.cost <= 0:
		return false
	if simulation.country.treasury < order.cost:
		return false
	if order.jobs_created < 0:
		return false
	return true
