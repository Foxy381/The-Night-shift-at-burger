extends Control


func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://TEST ROOMS/player_camera 2.tscn")

func _input(event):
	if event.is_action_pressed("ui_cancel"):  # ui_cancel - это стандартное действие для Escape
		get_tree().quit()  # Закрыть проект
