extends Control

@onready var date_label: Label = $Date
@onready var country_label: Label = $Country
@onready var stats_label: Label = $Stats
@onready var resources_label: Label = $Resources
@onready var advance_button: Button = $AdvanceButton
@onready var save_button: Button = $SaveButton
@onready var load_button: Button = $LoadButton
@onready var status_label: Label = $Status

func _ready() -> void:
	advance_button.pressed.connect(_on_advance_month)
	save_button.pressed.connect(_on_save)
	load_button.pressed.connect(_on_load)
	_refresh()

func _on_advance_month() -> void:
	GameSimulation.advance_month()
	status_label.text = "Прошёл один игровой месяц."
	_refresh()

func _on_save() -> void:
	if GameSimulation.save_game():
		status_label.text = "Игра сохранена."
	else:
		status_label.text = "Не удалось сохранить игру."

func _on_load() -> void:
	if GameSimulation.load_game():
		status_label.text = "Игра загружена."
		_refresh()
	else:
		status_label.text = "Сохранение не найдено или повреждено."

func _refresh() -> void:
	var country := GameSimulation.country
	date_label.text = "Дата: " + GameSimulation.get_date_text()
	country_label.text = "Государство: " + country.country_name
	stats_label.text = (
		"Население: %s\n" +
		"Рабочая сила: %s\n" +
		"Занятые: %s\n" +
		"Безработица: %.1f%%\n\n" +
		"Казна: %.0f\n" +
		"Доход / месяц: %.0f\n" +
		"Расходы / месяц: %.0f\n" +
		"Инфляция: %.1f%%\n\n" +
		"Благосостояние: %.1f\n" +
		"Доверие: %.1f\n" +
		"Коррупция: %.1f%%"
	) % [
		country.population, country.workforce, country.employed,
		country.get_unemployment_rate(), country.treasury,
		country.monthly_income, country.monthly_expenses,
		GameSimulation.economy.inflation, country.welfare,
		country.trust, country.corruption
	]

	resources_label.text = "Ресурсы\n\n"
	for resource in country.resources.values():
		resources_label.text += "%s: %.0f\nПроизводство: %.0f\nПотребление: %.0f\n\n" % [
			resource.resource_name, resource.amount,
			resource.production_per_month, resource.consumption_per_month
	]
