extends CanvasLayer  # Лучше использовать CanvasLayer для overlay-элементов

# Ширина чёрных полос в пикселях
@export var border_width: int = 175:
	set(value):
		border_width = max(0, value)  # Защита от отрицательных значений
		update_borders()

# Цвет полос
@export var border_color: Color = Color.BLACK

var left_border: ColorRect
var right_border: ColorRect

func _ready():
	# Создаём полосы
	create_borders()
	# Подключаем сигнал на изменение размера окна
	get_viewport().connect("size_changed", Callable(self, "_on_viewport_size_changed"))

func create_borders():
	# Удаляем старые полосы, если они есть
	if left_border:
		left_border.queue_free()
	if right_border:
		right_border.queue_free()
	
	# Создаём новые полосы
	left_border = create_border("LeftBorder", 0)
	right_border = create_border("RightBorder", get_viewport().get_visible_rect().size.x - border_width)
	
	add_child(left_border)
	add_child(right_border)

func create_border(name: String, x_pos: int) -> ColorRect:
	var border = ColorRect.new()
	border.name = name
	border.color = border_color
	border.size = Vector2(border_width, get_viewport().get_visible_rect().size.y)
	border.position = Vector2(x_pos, 0)
	return border

func _on_viewport_size_changed():
	update_borders()

func update_borders():
	var viewport_size = get_viewport().get_visible_rect().size
	
	if left_border:
		left_border.size = Vector2(border_width, viewport_size.y)
	
	if right_border:
		right_border.size = Vector2(border_width, viewport_size.y)
		right_border.position = Vector2(viewport_size.x - border_width, 0)
