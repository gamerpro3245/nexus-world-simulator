extends Control

var world := WorldState.new()
var order_queue := OrderQueue.new()
var order_processor := OrderProcessor.new()
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
	$Root/Main/Panel/SaveButton.pressed.connect(_save_game)
	$Root/Main/Panel/LoadButton.pressed.connect(_load_game)
	$Root/Main/Map.province_selected.connect(_select_province)
	_refresh()

func _select_province(id: int) -> void:
	selected_province=id
	var p=world.provinces[id-1]
	province_label.text="Провинция: %s\nНаселение: %s • Промышленность: %d\nРесурс: %s • Стабильность: %d%%" % [p.name,_format_number(p.population),p.industry,p.resource,p.stability]

func _add_order() -> void:
	var text:=order_input.text.strip_edges()
	if text.is_empty(): return
	var order:=NexusOrder.new(text); order.target_province=selected_province; order_queue.add(order)
	log_label.append_text("\n• [color=#8fb7c9]Приказ в очереди:[/color] "+text)
	order_input.clear(); status_label.text="В очереди приказов: %d" % order_queue.count()

func _advance_month() -> void:
	var count:=order_queue.count()
	for order in order_queue.pending: log_label.append_text("\n• "+order_processor.execute(world,order))
	world.advance_month(count); order_queue.clear(); _refresh(); status_label.text="Симуляция обновлена"

func _save_game() -> void:
	status_label.text="Игра сохранена" if SaveManager.save_world(world) else "Ошибка сохранения"

func _load_game() -> void:
	status_label.text="Игра загружена" if SaveManager.load_world(world) else "Сохранение не найдено"
	_refresh()

func _refresh() -> void:
	date_label.text="%02d.%04d" % [world.month,world.year]
	stats_label.text="Население  %s\nБюджет  %.0f\nБлагосостояние  %.1f\nДоверие  %.1f%%\nБезработица  %.1f%%\nКоррупция  %.1f%%\nПромышленность  %.1f\nНаука  %.1f" % [_format_number(world.population),world.treasury,world.welfare,world.trust,world.unemployment,world.corruption,world.industrial_capacity,world.research_points]
	_select_province(selected_province)

func _format_number(value:int)->String:
	var s:=str(value); var result:=""
	while s.length()>3: result=" "+s.substr(s.length()-3,3)+result; s=s.substr(0,s.length()-3)
	return s+result
