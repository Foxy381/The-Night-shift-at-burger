# Прикрепите этот скрипт к камере или родительскому узлу
extends Node3D

@export var spotlight: SpotLight3D
var raycast: RayCast3D

func _ready():
	# Создаем RayCast3D
	raycast = RayCast3D.new()
	add_child(raycast)
	raycast.enabled = true

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		# Получаем позицию мыши в мировых координатах
		var mouse_pos = get_viewport().get_mouse_position()
		var from = get_viewport().get_camera_3d().project_ray_origin(mouse_pos)
		var to = from + get_viewport().get_camera_3d().project_ray_normal(mouse_pos) * 1000
		
		raycast.target_position = to - global_position
		raycast.force_raycast_update()
		
		if raycast.is_colliding():
			var collider = raycast.get_collider()
			if collider is MeshInstance3D and collider.name == "ВашMeshInstance3D":
				# Переключаем состояние света
				spotlight.visible = !spotlight.visible
