extends CanvasLayer

class_name FNaF3DCamera

## Camera movement settings
@export_group("Movement")
@export var mouse_sensitivity: float = 0.1
@export var max_head_tilt: float = 15.0
@export var return_to_center_speed: float = 3.0
@export var movement_limit: Vector2 = Vector2(30, 20)  # X/Y movement limits

## Camera settings
@export_group("Camera")
@export var fov: float = 70.0:
	set(value):
		fov = clamp(value, 50, 90)
		if camera:
			camera.fov = fov
@export var camera_distance: float = 2.5:
	set(value):
		camera_distance = clamp(value, 1.0, 5.0)
		update_camera_position()

## References
@onready var sub_viewport: SubViewport = SubViewport.new()
@onready var camera_pivot: Node3D = Node3D.new()
@onready var camera: Camera3D = Camera3D.new()

## Runtime variables
var target_rotation: Vector3 = Vector3.ZERO
var current_rotation: Vector3 = Vector3.ZERO
var mouse_pos: Vector2 = Vector2.ZERO
var is_shaking: bool = false

func _ready():
	# Setup 3D rendering pipeline
	setup_viewport()
	
	# Configure camera
	setup_camera()
	
	# Initial positioning
	update_camera_position()
	
	# Connect signals
	get_viewport().size_changed.connect(_on_viewport_resized)

func setup_viewport():
	sub_viewport.name = "3DViewport"
	sub_viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	sub_viewport.transparent_bg = true
	add_child(sub_viewport)
	
	camera_pivot.name = "CameraPivot"
	sub_viewport.add_child(camera_pivot)
	
	camera.name = "SecurityCamera"
	camera_pivot.add_child(camera)

func setup_camera():
	camera.fov = fov
	camera.near = 0.1
	camera.far = 100.0
	camera.current = true
	camera.projection = Camera3D.PROJECTION_PERSPECTIVE

func _process(delta):
	if is_shaking: 
		return
	
	handle_mouse_look(delta)
	apply_camera_transform()

func handle_mouse_look(delta):
	var new_mouse_pos = get_viewport().get_mouse_position()
	var mouse_delta = (new_mouse_pos - mouse_pos) * mouse_sensitivity
	mouse_pos = new_mouse_pos
	
	# Calculate target rotation with limits
	target_rotation.x = clamp(target_rotation.x + mouse_delta.y, -max_head_tilt, max_head_tilt)
	target_rotation.y = clamp(target_rotation.y + mouse_delta.x, -movement_limit.x, movement_limit.x)
	
	# Smooth return to center
	if delta > 0:
		current_rotation = current_rotation.lerp(target_rotation, return_to_center_speed * delta)
		target_rotation = target_rotation.lerp(Vector3.ZERO, return_to_center_speed * delta * 0.5)

func apply_camera_transform():
	camera_pivot.rotation_degrees.x = current_rotation.x
	camera_pivot.rotation_degrees.y = current_rotation.y
	camera_pivot.rotation_degrees.z = current_rotation.z

func update_camera_position():
	camera.position = Vector3(0, 0, camera_distance)

func _on_viewport_resized():
	sub_viewport.size = get_viewport().size

## Special Effects
func apply_camera_shake(intensity: float = 0.7, duration: float = 0.8):
	if is_shaking: return
	
	is_shaking = true
	var original_rot = camera_pivot.rotation_degrees
	var elapsed = 0.0
	
	while elapsed < duration:
		var progress = elapsed / duration
		var current_intensity = intensity * (1.0 - progress)
		
		camera_pivot.rotation_degrees = original_rot + Vector3(
			randf_range(-current_intensity, current_intensity),
			randf_range(-current_intensity, current_intensity),
			0
		)
		
		elapsed += get_process_delta_time()
		await get_tree().process_frame
	
	camera_pivot.rotation_degrees = original_rot
	is_shaking = false

func static_effect(duration: float = 0.3):
	var static_mat = preload("res://Shaber/player_camera_shaber.gdshader")
	var static_rect = ColorRect.new()
	static_rect.material = static_mat
	static_rect.size = sub_viewport.size
	static_rect.z_index = 100
	add_child(static_rect)
	
	await get_tree().create_timer(duration).timeout
	static_rect.queue_free()
