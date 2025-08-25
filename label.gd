extends Label

@export_file("*.tscn") var target_scene: String

func _ready():
	mouse_filter = Control.MOUSE_FILTER_STOP

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if target_scene:
				get_tree().change_scene_to_file(target_scene)
