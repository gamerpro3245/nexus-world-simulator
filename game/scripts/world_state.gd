class_name WorldState
extends RefCounted

var year := 2026
var month := 3
var treasury := 1000.0
var population := 25_000_000
var welfare := 50.0
var trust := 50.0
var corruption := 20.0
var unemployment := 8.0
var industrial_capacity := 12.0
var research_points := 10.0

var provinces := [
	{"id": 1, "name": "Север", "population": 4200000, "industry": 3, "stability": 72, "resource": "железо"},
	{"id": 2, "name": "Северо-Запад", "population": 2800000, "industry": 2, "stability": 66, "resource": "уголь"},
	{"id": 3, "name": "Запад", "population": 5100000, "industry": 4, "stability": 78, "resource": "нефть"},
	{"id": 4, "name": "Центр", "population": 6200000, "industry": 5, "stability": 74, "resource": "электроника"},
	{"id": 5, "name": "Восток", "population": 3000000, "industry": 2, "stability": 61, "resource": "газ"},
	{"id": 6, "name": "Юг", "population": 3700000, "industry": 3, "stability": 69, "resource": "зерно"}
]

func advance_month(order_count: int) -> void:
	month += 1
	if month > 12:
		month = 1
		year += 1
	population += int(population * 0.002)
	treasury += industrial_capacity * 2.0 - order_count * 8.0
	welfare = clamp(welfare + (0.25 if order_count > 0 else -0.1), 0.0, 100.0)
	trust = clamp(trust + (0.15 if order_count > 0 else -0.2), 0.0, 100.0)
	corruption = clamp(corruption - (0.2 if order_count > 1 else -0.05), 0.0, 100.0)
	unemployment = clamp(unemployment - (0.15 if order_count > 0 else -0.03), 0.0, 100.0)
	research_points += 2.0
