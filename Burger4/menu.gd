extends Node3D

func _input(event):
	if event.is_action_pressed("ui_cancel"):  # ui_cancel - это стандартное действие для Escape
		get_tree().quit()  # Закрыть проект


func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://gggg.tscn")


func _on_texture_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://TEST ROOMS/control.tscn")
