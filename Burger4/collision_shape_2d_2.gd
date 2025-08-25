extends CollisionShape2D

func _ready():
	# Включаем обработку ввода
	set_process_input(true)

func _input(event):
	if event is InputEventMouseMotion:
		var mouse_pos = get_global_mouse_position()
		
		# Проверяем что shape существует
		if shape != null:
			# Используем правильный метод для проверки коллизии
			var local_mouse_pos = to_local(mouse_pos)
			
			# Для разных типов форм нужны разные подходы проверки
			if is_point_inside_shape(local_mouse_pos):
				Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			else:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

# Функция для проверки находится ли точка внутри формы
func is_point_inside_shape(point: Vector2) -> bool:
	if shape is RectangleShape2D:
		var rect = Rect2(Vector2.ZERO, shape.size)
		return rect.has_point(point)
	elif shape is CircleShape2D:
		return point.length() <= shape.radius
	elif shape is CapsuleShape2D:
		# Более сложная проверка для капсулы
		var radius = shape.radius
		var height = shape.height
		# Упрощенная проверка - рассматриваем как прямоугольник с закругленными углами
		var rect = Rect2(Vector2(-radius, -height/2), Vector2(radius*2, height))
		return rect.has_point(point)
	
	return false
