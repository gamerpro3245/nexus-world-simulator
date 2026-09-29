extends Control

@onready var date_label: Label = $Date
@onready var country_label: Label = $Country
@onready var stats_label: Label = $Stats
@onready var resources_label: Label = $Resources
@onready var construction_label: Label = $Construction
@onready var advance_button: Button = $AdvanceButton
@onready var factory_button: Button = $FactoryButton
@onready var electronics_button: Button = $ElectronicsButton
@onready var power_button: Button = $PowerButton
@onready var save_button: Button = $SaveButton
@onready var load_button: Button = $LoadButton
@onready var status_label: Label = $Status

func _ready() -> void:
	advance_button.pressed.connect(_on_advance_month)
	factory_button.pressed.connect(_on_factory)
	electronics_button.pressed.connect(_on_electronics)
	power_button.pressed.connect(_on_power)
	save_button.pressed.connect(_on_save)
	load_button.pressed.connect(_on_load)
	_refresh()

func _on_advance_month() -> void:
	GameSimulation.advance_month()
	status_label.text = "Прошёл один игровой месяц."
	_refresh()

func _on_factory() -> void:
	if GameSimulation.build_factory(0):
		status_label.text = "Приказ принят: строительство завода в провинции 1."
	else:
		status_label.text = "Приказ отклонён: недостаточно средств или неверные параметры."
	_refresh()

func _on_electronics() -> void:
	if GameSimulation.build_electronics_factory(0):
		status_label.text = "Приказ принят: строительство электронного завода в провинции 1."
	else:
		status_label.text = "Приказ отклонён: недостаточно средств или неверные параметры."
	_refresh()

func _on_power() -> void:
	if GameSimulation.build_power_plant(0):
		status_label.text = "Приказ принят: строительство электростанции в провинции 1."
	else:
		status_label.text = "Приказ отклонён: недостаточно средств или неверные параметры."
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
		"Население: %s\nРабочая сила: %s\nЗанятые: %s\nБезработица: %.1f%%\n\n" +
		"Казна: %.0f\nДоход / месяц: %.0f\nРасходы / месяц: %.0f\n" +
		"Инфляция: %.1f%%\n\nБлагосостояние: %.1f\nДоверие: %.1f\nКоррупция: %.1f%%"
	) % [country.population, country.workforce, country.employed, country.get_unemployment_rate(), country.treasury, country.monthly_income, country.monthly_expenses, GameSimulation.economy.inflation, country.welfare, country.trust, country.corruption]

	resources_label.text = "Ресурсы\n\n"
	for resource in country.resources.values():
		resources_label.text += "%s: %.0f\nПроизводство: %.0f\nПотребление: %.0f\n\n" % [resource.resource_name, resource.amount, resource.production_per_month, resource.consumption_per_month]

	construction_label.text = "Строительство\n\n"
	if GameSimulation.construction_projects.is_empty():
		construction_label.text += "Нет активных проектов"
	else:
		for project in GameSimulation.construction_projects:
			construction_label.text += "%s\nПровинция: %d\nОсталось месяцев: %d\n\n" % [project.building_type, project.province_id + 1, project.months_left]
