extends Control

var world := WorldState.new()
var orders: Array[String] = []
var selected_province := 4

@onready var date_label: Label = $Root/Header/Date
@onready var stats_label: Label = $Root/Main/Panel/Stats
@onready var province_label: Label = $Root/Main/Panel/Province
@onready var order_input: LineEdit = $Root/Main/Panel/OrderInput
@onready var log_label: RichTextLabel = $Root/Main/Panel/Log
@onready var status_label: Label = $Root/Footer/Status

func _ready() -> void:
	$Root/Main/Panel/OrderButton.pressed.connect(_add_order)
	$Root/Main/Panel/AdvanceButton.pressed.connect(_advance_month)
	$Root/Main/Map.province_selected.connect(_select_province)
	_refresh()

func _select_province(id: int) -> void:
	selected_province = id
	var p = world.provinces[id - 1]
	province_label.text = "Провинция: %s\nНаселение: %s • Промышленность: %d\nРесурс: %s • Стабильность: %d%%" % [p.name, _format_number(p.population), p.industry, p.resource, p.stability]

func _add_order() -> void:
	var text := order_input.text.strip_edges()
	if text.is_empty():
		return
	orders.append(text)
	log_label.append_text("\n• [color=#8fb7c9]Приказ принят:[/color] " + text)
	order_input.clear()
	status_label.text = "В очереди приказов: %d" % orders.size()

func _advance_month() -> void:
	world.advance_month(orders.size())
	if not orders.is_empty():
		log_label.append_text("\n• Выполнено приказов: %d" % orders.size())
		orders.clear()
	_refresh()
	status_label.text = "Симуляция обновлена"

func _refresh() -> void:
	date_label.text = "%02d.%04d" % [world.month, world.year]
	stats_label.text = "Население  %s\nБюджет  %.0f\nБлагосостояние  %.1f\nДоверие  %.1f%%\nБезработица  %.1f%%\nКоррупция  %.1f%%\nПромышленность  %.1f\nНаука  %.1f" % [_format_number(world.population), world.treasury, world.welfare, world.trust, world.unemployment, world.corruption, world.industrial_capacity, world.research_points]
	_select_province(selected_province)

func _format_number(value: int) -> String:
	var s := str(value)
	var result := ""
	while s.length() > 3:
		result = " " + s.substr(s.length() - 3, 3) + result
		s = s.substr(0, s.length() - 3)
	return s + result
