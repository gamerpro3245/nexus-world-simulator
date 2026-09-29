class_name NexusEconomy
extends RefCounted

var industrial_output: float = 100.0
var consumer_demand: float = 100.0
var inflation: float = 4.0
var tax_rate: float = 20.0
var investment_rate: float = 10.0

func simulate_month(country: NexusCountry) -> void:
	var employment_factor := 1.0 - country.get_unemployment_rate() / 100.0
	industrial_output = maxf(0.0, industrial_output * (1.0 + 0.002 * employment_factor))
	consumer_demand = maxf(0.0, consumer_demand * (1.0 + country.welfare * 0.0005))

	country.monthly_income = 100_000.0 + industrial_output * 1_000.0 * tax_rate / 20.0
	country.monthly_expenses = 90_000.0 + investment_rate * 1_500.0
	inflation = maxf(0.0, inflation + (consumer_demand - industrial_output) * 0.001)

func to_dict() -> Dictionary:
	return {
		"industrial_output": industrial_output,
		"consumer_demand": consumer_demand,
		"inflation": inflation,
		"tax_rate": tax_rate,
		"investment_rate": investment_rate
	}

func from_dict(data: Dictionary) -> void:
	industrial_output = float(data.get("industrial_output", industrial_output))
	consumer_demand = float(data.get("consumer_demand", consumer_demand))
	inflation = float(data.get("inflation", inflation))
	tax_rate = float(data.get("tax_rate", tax_rate))
	investment_rate = float(data.get("investment_rate", investment_rate))
