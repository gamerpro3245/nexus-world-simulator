extends Node

func _ready() -> void:
	print("NEXUS запущен")
	print("Дата симуляции: ", GameSimulation.get_date_text())
	print("Страна: ", GameSimulation.country.country_name)
