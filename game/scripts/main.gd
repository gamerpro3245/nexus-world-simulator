extends Control

@onready var date_label: Label = $Date
@onready var country_label: Label = $Country
@onready var stats_label: Label = $Stats
@onready var advance_button: Button = $AdvanceButton

func _ready() -> void:
	advance_button.pressed.connect(_on_advance_month)
	_refresh()

func _on_advance_month() -> void:
	GameSimulation.advance_month()
	_refresh()

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
		"Расходы / месяц: %.0f\n\n" +
		"Благосостояние: %.1f\n" +
		"Доверие: %.1f\n" +
		"Коррупция: %.1f%%"
	) % [
		country.population,
		country.workforce,
		country.employed,
		country.get_unemployment_rate(),
		country.treasury,
		country.monthly_income,
		country.monthly_expenses,
		country.welfare,
		country.trust,
		country.corruption
	]
