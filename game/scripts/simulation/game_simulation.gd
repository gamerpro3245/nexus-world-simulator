class_name NexusGameSimulation
extends Node

var country: NexusCountry
var year: int = 2026
var month: int = 1

func _ready() -> void:
	_initialize_world()

func _initialize_world() -> void:
	country = NexusCountry.new()

	for i in range(10):
		var province_population := int(country.population / 10)
		var province := NexusProvince.new(i + 1, "Провинция %02d" % (i + 1), province_population)
		country.provinces.append(province)

func advance_month() -> void:
	country.apply_monthly_economy()

	month += 1
	if month > 12:
		month = 1
		year += 1

func get_date_text() -> String:
	return "%02d.%04d" % [month, year]
