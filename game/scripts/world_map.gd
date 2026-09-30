class_name WorldMap
extends Control

signal province_selected(id: int)

var provinces := [
	{"id": 1, "name": "Север", "pos": Vector2(0.22, 0.28), "size": Vector2(0.24, 0.20)},
	{"id": 2, "name": "Северо-Запад", "pos": Vector2(0.47, 0.20), "size": Vector2(0.22, 0.24)},
	{"id": 3, "name": "Запад", "pos": Vector2(0.12, 0.52), "size": Vector2(0.28, 0.25)},
	{"id": 4, "name": "Центр", "pos": Vector2(0.42, 0.47), "size": Vector2(0.27, 0.28)},
	{"id": 5, "name": "Восток", "pos": Vector2(0.70, 0.34), "size": Vector2(0.23, 0.30)},
	{"id": 6, "name": "Юг", "pos": Vector2(0.38, 0.78), "size": Vector2(0.28, 0.16)}
]
var selected := 4

func _ready() -> void:
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	queue_redraw()

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		for p in provinces:
			var center := Vector2(size.x * p.pos.x, size.y * p.pos.y)
			var rect := Rect2(center - Vector2(size.x * p.size.x, size.y * p.size.y) * 0.5, Vector2(size.x * p.size.x, size.y * p.size.y))
			if rect.has_point(event.position):
				selected = p.id
				province_selected.emit(selected)
				queue_redraw()
				return

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color("#111923"))
	draw_circle(Vector2(size.x * 0.52, size.y * 0.52), min(size.x, size.y) * 0.38, Color("#172c3b"))
	for p in provinces:
		var center := Vector2(size.x * p.pos.x, size.y * p.pos.y)
		var rect_size := Vector2(size.x * p.size.x, size.y * p.size.y)
		var rect := Rect2(center - rect_size * 0.5, rect_size)
		var fill := Color("#35566b") if p.id != selected else Color("#5c8fa8")
		var border := Color("#8fb7c9") if p.id == selected else Color("#48697a")
		draw_style_box(_box(fill, border, 3), rect)
		draw_string(ThemeDB.fallback_font, center - Vector2(30, -5), p.name, HORIZONTAL_ALIGNMENT_CENTER, 60, 18, Color.WHITE)

func _box(bg: Color, border: Color, width: int) -> StyleBoxFlat:
	var box := StyleBoxFlat.new()
	box.bg_color = bg
	box.border_color = border
	box.set_border_width_all(width)
	box.corner_radius_top_left = 10
	box.corner_radius_top_right = 10
	box.corner_radius_bottom_left = 10
	box.corner_radius_bottom_right = 10
	return box
