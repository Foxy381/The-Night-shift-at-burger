extends CollisionShape2D

@export_file("res://TEST ROOMS/player_camera.tscn") var target_scene: String

func _ready():
	# Включаем обработку ввода
	set_process_input(true)

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			# Проверяем, находится ли курсор над CollisionShape2D
			var mouse_pos = get_global_mouse_position()
			if is_point_inside_collision(mouse_pos):
				if target_scene:
					get_tree().change_scene_to_file(target_scene)

# Функция для проверки, находится ли точка внутри CollisionShape2D
func is_point_inside_collision(point: Vector2) -> bool:
	if shape == null:
		return false
	
	# Преобразуем глобальные координаты в локальные
	var local_point = to_local(point)
	
	# Проверяем для разных типов форм
	if shape is RectangleShape2D:
		var rect = Rect2(-shape.size / 2, shape.size)
		return rect.has_point(local_point)
	elif shape is CircleShape2D:
		return local_point.length() <= shape.radius
	elif shape is CapsuleShape2D:
		# Упрощенная проверка для капсулы
		var rect = Rect2(Vector2(-shape.radius, -shape.height / 2), 
					   Vector2(shape.radius * 2, shape.height))
		return rect.has_point(local_point)
	
	return false
