class_name NexusCountry
extends RefCounted

var country_name: String = "Новая Республика"
var population: int = 10_000_000
var workforce: int = 5_000_000
var employed: int = 4_600_000
var treasury: float = 1_000_000.0
var monthly_income: float = 120_000.0
var monthly_expenses: float = 110_000.0
var welfare: float = 60.0
var trust: float = 50.0
var corruption: float = 25.0
var provinces: Array[NexusProvince] = []
var resources: Dictionary = {}

func get_unemployment_rate() -> float:
	if workforce <= 0:
		return 0.0
	return float(workforce - employed) / float(workforce) * 100.0

func apply_monthly_economy(economy: NexusEconomy) -> void:
	economy.simulate_month(self)
	treasury += monthly_income - monthly_expenses
	welfare = clampf(welfare + 0.05 - economy.inflation * 0.002, 0.0, 100.0)
	trust = clampf(trust + 0.02 - corruption * 0.001, 0.0, 100.0)
	corruption = clampf(corruption - 0.01, 0.0, 100.0)
	for resource in resources.values():
		resource.simulate_month()

func to_dict() -> Dictionary:
	var province_data: Array = []
	for province in provinces:
		province_data.append({
			"id": province.id,
			"name": province.province_name,
			"population": province.population,
			"infrastructure": province.infrastructure,
			"jobs": province.jobs,
			"production": province.production,
			"development": province.development
		})
	var resource_data: Dictionary = {}
	for key in resources:
		resource_data[key] = resources[key].to_dict()
	return {
		"country_name": country_name,
		"population": population,
		"workforce": workforce,
		"employed": employed,
		"treasury": treasury,
		"monthly_income": monthly_income,
		"monthly_expenses": monthly_expenses,
		"welfare": welfare,
		"trust": trust,
		"corruption": corruption,
		"provinces": province_data,
		"resources": resource_data
	}

func from_dict(data: Dictionary) -> void:
	country_name = str(data.get("country_name", country_name))
	population = int(data.get("population", population))
	workforce = int(data.get("workforce", workforce))
	employed = int(data.get("employed", employed))
	treasury = float(data.get("treasury", treasury))
	monthly_income = float(data.get("monthly_income", monthly_income))
	monthly_expenses = float(data.get("monthly_expenses", monthly_expenses))
	welfare = float(data.get("welfare", welfare))
	trust = float(data.get("trust", trust))
	corruption = float(data.get("corruption", corruption))
	provinces.clear()
	for raw in data.get("provinces", []):
		var province := NexusProvince.new(
			int(raw.get("id", 0)),
			str(raw.get("name", "Провинция")),
			int(raw.get("population", 0))
		)
		province.infrastructure = float(raw.get("infrastructure", 50.0))
		province.jobs = int(raw.get("jobs", 0))
		province.production = float(raw.get("production", 0.0))
		province.development = float(raw.get("development", 50.0))
		provinces.append(province)
	resources.clear()
	for key in data.get("resources", {}):
		var raw_resource: Dictionary = data["resources"][key]
		resources[key] = NexusResource.new(
			str(raw_resource.get("name", key)),
			float(raw_resource.get("amount", 0.0)),
			float(raw_resource.get("production", 0.0)),
			float(raw_resource.get("consumption", 0.0)),
			float(raw_resource.get("price", 1.0))
		)
