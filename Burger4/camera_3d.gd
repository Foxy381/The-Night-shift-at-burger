extends Camera3D  # Должен быть прикреплен к родительскому узлу камеры

# Настройки поворота
var rot_y = 0.0  # Текущий угол поворота
var rot_speed = 0.001  # Скорость поворота
var max_angle = deg_to_rad(20)  # Максимальный угол поворота (20 градусов)

func _input(event):
	if event is InputEventMouseMotion:
		# Поворот только по горизонтали (оси Y)
		rot_y -= event.relative.x * rot_speed
		
		# Ограничение угла поворота
		rot_y = clamp(rot_y, -max_angle, max_angle)
		
		# Применяем поворот
		transform.basis = Basis(Vector3.UP, rot_y)
