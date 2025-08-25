extends TextureButton

@export var animation_player: AnimationPlayer
var is_first_animation: bool = true

func _ready():
	# Подключаем сигнал нажатия кнопки
	pressed.connect(_on_texture_button_pressed)
	
	# Если AnimationPlayer не назначен в редакторе, попробуем найти его автоматически
	if animation_player == null:
		# Проверяем, существует ли путь к AnimationPlayer
		var potential_path = $"../../Camera3D/AnimationPlayer"
		if potential_path:
			animation_player = potential_path
		else:
			push_error("AnimationPlayer не найден по указанному пути!")

func _on_texture_button_pressed():
	if animation_player:
		if is_first_animation:
			# Запускаем первую анимацию
			if animation_player.has_animation("up"):
				animation_player.play("up")
			else:
				push_error("Анимация 'up' не найдена!")
		else:
			# Запускаем вторую анимацию
			if animation_player.has_animation("Down"):
				animation_player.play("Down")
			else:
				push_error("Анимация 'Down' не найдена!")
		
		# Переключаем флаг для следующего клика
		is_first_animation = !is_first_animation
	else:
		push_error("AnimationPlayer не найден!")
