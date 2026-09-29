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

func get_unemployment_rate() -> float:
	if workforce <= 0:
		return 0.0
	return float(workforce - employed) / float(workforce) * 100.0

func apply_monthly_economy() -> void:
	treasury += monthly_income - monthly_expenses

	welfare = clampf(welfare + 0.05, 0.0, 100.0)
	trust = clampf(trust + 0.02 - corruption * 0.001, 0.0, 100.0)
	corruption = clampf(corruption - 0.01, 0.0, 100.0)
