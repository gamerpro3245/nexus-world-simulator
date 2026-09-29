class_name NexusGameSimulation
extends Node

var country: NexusCountry
var economy: NexusEconomy
var save_manager: NexusSaveManager
var year: int = 2026
var month: int = 1

func _ready() -> void:
	_initialize_world()

func _initialize_world() -> void:
	country = NexusCountry.new()
	economy = NexusEconomy.new()
	save_manager = NexusSaveManager.new()
	for i in range(10):
		var province_population := int(country.population / 10)
		country.provinces.append(NexusProvince.new(i + 1, "Провинция %02d" % (i + 1), province_population))
	country.resources["energy"] = NexusResource.new("Энергия", 5000.0, 600.0, 550.0, 1.0)
	country.resources["steel"] = NexusResource.new("Сталь", 3000.0, 250.0, 220.0, 2.0)
	country.resources["food"] = NexusResource.new("Продовольствие", 8000.0, 1000.0, 950.0, 0.5)

func advance_month() -> void:
	country.apply_monthly_economy(economy)
	month += 1
	if month > 12:
		month = 1
		year += 1

func save_game() -> bool:
	return save_manager.save_game(self)

func load_game() -> bool:
	return save_manager.load_game(self)

func to_dict() -> Dictionary:
	var data := country.to_dict()
	data["year"] = year
	data["month"] = month
	data["economy"] = economy.to_dict()
	return data

func from_dict(data: Dictionary) -> void:
	year = int(data.get("year", 2026))
	month = int(data.get("month", 1))
	country.from_dict(data)
	economy.from_dict(data.get("economy", {}))

func get_date_text() -> String:
	return "%02d.%04d" % [month, year]
