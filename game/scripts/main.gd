extends Control

var year := 2026
var month := 3
var population := 25_000_000
var welfare := 50
var trust := 50
var unemployment := 8
var budget := 1000
var corruption := 20
var orders: Array[String] = []

@onready var date_label: Label = $Root/Header/Date
@onready var stats_label: Label = $Root/Body/Sidebar/Stats
@onready var order_input: LineEdit = $Root/Body/Sidebar/OrderInput
@onready var log_label: RichTextLabel = $Root/Body/Sidebar/Log
@onready var status_label: Label = $Root/Footer/Status

func _ready() -> void:
	$Root/Body/Sidebar/OrderButton.pressed.connect(_add_order)
	$Root/Body/Sidebar/AdvanceButton.pressed.connect(_advance_month)
	_refresh()

func _add_order() -> void:
	var order := order_input.text.strip_edges()
	if order.is_empty():
		return
	orders.append(order)
	log_label.append_text("\n• Приказ принят: " + order)
	order_input.clear()
	status_label.text = "Приказов в очереди: %d" % orders.size()

func _advance_month() -> void:
	month += 1
	if month > 12:
		month = 1
		year += 1
	population += int(population * 0.002)
	welfare = clamp(welfare + (1 if orders.size() > 0 else 0), 0, 100)
	trust = clamp(trust + (1 if orders.size() > 0 else 0), 0, 100)
	unemployment = clamp(unemployment - (1 if orders.size() > 1 else 0), 0, 100)
	budget -= orders.size() * 5
	corruption = clamp(corruption - (1 if orders.size() > 2 else 0), 0, 100)
	if not orders.is_empty():
		log_label.append_text("\n• Выполнено приказов: %d" % orders.size())
		orders.clear()
	_refresh()

func _refresh() -> void:
	date_label.text = "%02d.%02d.%04d" % [1, month, year]
	stats_label.text = "Население: %s\nБлагосостояние: %d\nДоверие: %d%%\nБезработица: %d%%\nБюджет: %d\nКоррупция: %d%%" % [
		_format_number(population), welfare, trust, unemployment, budget, corruption
	]

func _format_number(value: int) -> String:
	var s := str(value)
	var result := ""
	while s.length() > 3:
		result = " " + s.substr(s.length() - 3, 3) + result
		s = s.substr(0, s.length() - 3)
	return s + result
