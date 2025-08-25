extends CSGBox3D
# Перетащите сюда ваш MeshInstance3D из сцены
@export var mesh_instance: MeshInstance3D

func _ready():
	# Настраиваем обработку кликов для MeshInstance3D
	setup_mesh_click_detection()

func _input(event):
	# Оригинальная функция для клавиши 3.2
	if event.is_action_pressed("guiClick3"):
		visible = !visible  # Переключаем видимость (вкл/выкл)
		print("Переключено клавишей: ", visible)
	
	# Добавляем обработку клика на MeshInstance3D
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		check_mesh_click()

func setup_mesh_click_detection():
	if mesh_instance:
		# Проверяем и добавляем коллизию если нужно
		if not has_collision(mesh_instance):
			add_collision_to_mesh()
		
		# Включаем обработку ввода для меша
		mesh_instance.input_ray_pickable = true
	else:
		print("Ошибка: MeshInstance3D не назначен!")

func has_collision(target_node: Node) -> bool:
	for child in target_node.get_children():
		if child is CollisionShape3D or child is CollisionPolygon3D:
			return true
	return false

func add_collision_to_mesh():
	var collision = CollisionShape3D.new()
	var shape = BoxShape3D.new()
	
	# Настраиваем размер коллизии под меш
	if mesh_instance.mesh:
		var aabb = mesh_instance.mesh.get_aabb()
		shape.size = aabb.size * 1.1
	else:
		shape.size = Vector3(2, 2, 2)
	
	collision.shape = shape
	mesh_instance.add_child(collision)
	print("Коллизия добавлена к MeshInstance3D1")

func check_mesh_click():
	if not mesh_instance:
		return
	
	# Создаем raycast для проверки клика
	var camera = get_viewport().get_camera_3d()
	var mouse_pos = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * 1000
	
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to)
	var result = space_state.intersect_ray(query)
	
	if result:
		var collider = result.get("collider")
		if collider and collider.get_parent() == mesh_instance:
			toggle_visibility_from_click()

func toggle_visibility_from_click():
	visible = !visible
	print("Переключено кликом на меш: ", visible)
