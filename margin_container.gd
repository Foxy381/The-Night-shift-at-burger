extends MarginContainer

const first_scene = preload("res://TEST ROOMS/player_camera.tscn")

var current_selection =0 


	
func handle_selection(_current_selection):
	if _current_selection == 0:
		get_parent().add_child(first_scene.instance())
