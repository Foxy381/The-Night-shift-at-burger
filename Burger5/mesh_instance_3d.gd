# Прикрепите этот скрипт к вашему MeshInstance3D
extends MeshInstance3D

# Перетащите сюда ваш Spotlight3D из сцены
@export var spotlight: SpotLight3D

func _ready():
	# Проверяем наличие коллизии
	if not _has_collision():
		print("Добавьте CollisionShape3D для кликов мышью")

func _has_collision():
	# Проверяем есть ли коллизия у объекта
	for child in get_children():
		if child is CollisionShape3D:
			return true
	return false

func _input_event(camera, event, position, normal, shape_idx):
	# Обрабатываем клик левой кнопкой мыши
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		toggle_spotlight()

func toggle_spotlight():
	if spotlight:
		# Меняем видимость на противоположную
		spotlight.visible = !spotlight.visible
		print("Spotlight: ", "ВКЛ" if spotlight.visible else "ВЫКЛ")
	else:
		print("Spotlight не назначен!")
