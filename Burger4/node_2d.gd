extends Node2D

const HOVER_FADE_DURATION: float = 0.3
const HOVER_ALPHA: float = 0.8  # Добавлена константа для прозрачности при наведении

@export_group("Setup")
@export var camera: Camera3D  # Убедитесь, что это правильный тип камеры
@export var office: Node3D   # Лучше использовать конкретный тип, если возможно

var is_tablet_up: bool = false
var tweener: Tween

@onready var tablet_button: TextureButton = %Tablet_Button  # Лучше использовать уникальные имена
@onready var tablet_sprite: AnimatedSprite2D = %Tablet_Sprite


func _on_tablet_button_click() -> void:
	# Останавливаем предыдущий твин, если был
	if tweener:
		tweener.kill()
	
	if not is_tablet_up:
		tablet_sprite.play("lift")
		tablet_sprite.visible = true
		if office:
			office.can_move = false
	else:
		tablet_sprite.play_backwards("lift")
		if tablet_button:
			tablet_button.disabled = true
		if camera:
			camera.visible = false

func _tablet_animation_finished() -> void:
	if not is_tablet_up:
		is_tablet_up = true
		if camera:
			camera.visible = true
			if camera.has_method("play_static"):
				camera.play_static()
	else:
		is_tablet_up = false
		if tablet_sprite:
			tablet_sprite.visible = false
		if office:
			office.can_move = true
		if tablet_button:
			tablet_button.disabled = false

func _on_tablet_button_hover() -> void:
	if tweener:
		tweener.kill()
	tweener = create_tween()
	tweener.tween_property(tablet_button, "modulate:a", HOVER_ALPHA, HOVER_FADE_DURATION)

func _on_tablet_button_unhover() -> void:
	if tweener:
		tweener.kill()
	tweener = create_tween()
	tweener.tween_property(tablet_button, "modulate:a", 1.0, HOVER_FADE_DURATION)
