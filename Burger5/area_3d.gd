# Прикрепите этот скрипт к Area3D (должен быть дочерним для MeshInstance3D)
extends Area3D

@export var spotlight: SpotLight3D  # Перетащите сюда ваш Spotlight3D

func _ready():
	# Подключаем сигнал клика
	connect("input_event", _on_input_event)
	
	# Проверяем наличие коллизии
	if not _has_collision():
		print("Предупреждение: Добавьте CollisionShape3D к Area3D")

func _has_collision():
	for child in get_children():
		if child is CollisionShape3D:
			return true
	return false

func _on_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		toggle_spotlight()

func toggle_spotlight():
	if spotlight:
		spotlight.visible = !spotlight.visible
		print("Spotlight переключен: ", "ВКЛ" if spotlight.visible else "ВЫКЛ")
