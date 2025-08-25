extends Area2D

@export_file("res://TEST ROOMS/player_camera.tscn") var target_scene: String

func _ready():
	# Подключаем сигнал клика
	input_event.connect(_on_input_event)

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if target_scene:
				get_tree().change_scene_to_file(target_scene)
