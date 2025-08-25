extends Node



func _input(event):
	if event.is_action_pressed("ui_cancel"):  # ui_cancel - это стандартное действие для Escape
		get_tree().quit()  # Закрыть проект
