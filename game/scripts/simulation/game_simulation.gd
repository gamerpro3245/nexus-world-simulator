class_name NexusGameSimulation
extends Node

var country: NexusCountry
var economy: NexusEconomy
var save_manager: NexusSaveManager
var order_processor: NexusOrderProcessor
var order_factory: NexusOrderFactory
var construction_projects: Array[NexusConstructionProject] = []
var year: int = 2026
var month: int = 1

func _ready() -> void:
	_initialize_world()

func _initialize_world() -> void:
	country = NexusCountry.new()
	economy = NexusEconomy.new()
	save_manager = NexusSaveManager.new()
	order_processor = NexusOrderProcessor.new()
	order_factory = NexusOrderFactory.new()
	for i in range(10):
		var province_population := int(country.population / 10)
		country.provinces.append(NexusProvince.new(i + 1, "Провинция %02d" % (i + 1), province_population))
	country.resources["energy"] = NexusResource.new("Энергия", 5000.0, 600.0, 550.0, 1.0)
	country.resources["steel"] = NexusResource.new("Сталь", 3000.0, 250.0, 220.0, 2.0)
	country.resources["food"] = NexusResource.new("Продовольствие", 8000.0, 1000.0, 950.0, 0.5)

func issue_order(order: NexusOrder) -> bool:
	return order_processor.execute(order, self)

func build_factory(province_id: int) -> bool:
	return issue_order(order_factory.build_factory(province_id))

func build_electronics_factory(province_id: int) -> bool:
	return issue_order(order_factory.build_electronics_factory(province_id))

func build_power_plant(province_id: int) -> bool:
	return issue_order(order_factory.build_power_plant(province_id))

func advance_month() -> void:
	country.apply_monthly_economy(economy)
	_process_construction()
	month += 1
	if month > 12:
		month = 1
		year += 1

func _process_construction() -> void:
	var completed: Array[NexusConstructionProject] = []
	for project in construction_projects:
		if project.advance_month():
			completed.append(project)
	for project in completed:
		_complete_project(project)
		construction_projects.erase(project)

func _complete_project(project: NexusConstructionProject) -> void:
	if project.province_id < 0 or project.province_id >= country.provinces.size():
		return
	var province := country.provinces[project.province_id]
	province.jobs += project.jobs_created
	province.production += project.production_bonus
	province.development = clampf(province.development + 5.0, 0.0, 100.0)
	country.employed = min(country.workforce, country.employed + project.jobs_created)

func save_game() -> bool:
	return save_manager.save_game(self)

func load_game() -> bool:
	return save_manager.load_game(self)

func to_dict() -> Dictionary:
	var data := country.to_dict()
	data["year"] = year
	data["month"] = month
	data["economy"] = economy.to_dict()
	var projects: Array = []
	for project in construction_projects:
		projects.append(project.to_dict())
	data["construction_projects"] = projects
	return data

func from_dict(data: Dictionary) -> void:
	year = int(data.get("year", 2026))
	month = int(data.get("month", 1))
	country.from_dict(data)
	economy.from_dict(data.get("economy", {}))
	construction_projects.clear()
	for raw in data.get("construction_projects", []):
		construction_projects.append(NexusConstructionProject.new(
			int(raw.get("province_id", 0)),
			str(raw.get("building_type", "Завод")),
			int(raw.get("months_left", 1)),
			float(raw.get("cost", 0.0)),
			int(raw.get("jobs_created", 0)),
			float(raw.get("production_bonus", 0.0))
		))

func get_date_text() -> String:
	return "%02d.%04d" % [month, year]
