extends CanvasLayer

class_name NightIntroOverlay

@export_group("Настройки интро")
@export var night_number: int = 99
@export var show_duration: float = 2.0
@export var hold_duration: float = 3.0
@export var fade_duration: float = 1.5
@export var reverse_delay: float = 5.0  # Задержка перед обратной анимацией
@export var reverse_animation: bool = true  # Включить ли обратную анимацию

@export_group("Внешний вид")
@export var stripe_color: Color = Color.BLACK
@export var text_color: Color = Color.WHITE
@export var stripe_height: float = 100.0
@export var font_size: int = 56

# Ссылки на ноды
var stripe_rect: ColorRect
var night_label: Label
var tween: Tween

func _ready():
	# Создаём элементы интерфейса
	create_ui_elements()
	
	# Скрываем всё initially
	hide_overlay()
	
	# Автозапуск интро
	start_night_intro()

func create_ui_elements():
	# Создаём чёрную полосу
	stripe_rect = ColorRect.new()
	stripe_rect.name = "StripeRect"
	stripe_rect.color = stripe_color
	stripe_rect.size = Vector2(get_viewport().size.x, stripe_height)
	stripe_rect.position = Vector2(0, get_viewport().size.y / 2 - stripe_height / 2)
	add_child(stripe_rect)
	
	# Создаём текст ночи
	night_label = Label.new()
	night_label.name = "NightLabel"
	night_label.text = "NIGHT %d" % night_number
	night_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	night_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	
	# Настраиваем шрифт
	var font = load("res://path_to_your_font.tres") # Замените на ваш шрифт
	if font:
		night_label.add_theme_font_override("font", font)
	night_label.add_theme_font_size_override("font_size", font_size)
	night_label.add_theme_color_override("font_color", text_color)
	
	# Позиционируем текст
	night_label.size = Vector2(get_viewport().size.x, 100)
	night_label.position = Vector2(0, get_viewport().size.y / 2 - 50)
	add_child(night_label)

func start_night_intro():
	show_overlay()
	
	# Создаём последовательность анимации
	tween = create_tween()
	tween.set_parallel(false)
	
	# Фаза 1: Появление
	tween.tween_method(Callable(self, "update_stripe_animation"), 0.0, 1.0, show_duration)
	tween.tween_interval(0.5)
	
	# Фаза 2: Удержание
	tween.tween_interval(hold_duration)
	
	# Фаза 3: Исчезновение
	tween.tween_method(Callable(self, "update_stripe_animation"), 1.0, 0.0, fade_duration)
	tween.tween_callback(Callable(self, "hide_overlay"))
	
	# Если включена обратная анимация, запускаем её через задержку
	if reverse_animation:
		tween.tween_interval(reverse_delay)
		tween.tween_callback(Callable(self, "start_reverse_animation"))

func start_reverse_animation():
	# Обратная анимация: появляемся снова и исчезаем
	show_overlay()
	
	tween = create_tween()
	tween.set_parallel(false)
	
	# Обратная фаза 1: Появление
	tween.tween_method(Callable(self, "update_stripe_animation"), 0.0, 1.0, fade_duration)
	tween.tween_interval(0.5)
	
	# Обратная фаза 2: Короткое удержание
	tween.tween_interval(hold_duration / 2)
	
	# Обратная фаза 3: Исчезновение
	tween.tween_method(Callable(self, "update_stripe_animation"), 1.0, 0.0, show_duration)
	tween.tween_callback(Callable(self, "hide_overlay"))
	tween.tween_callback(Callable(self, "queue_free"))  # Удаляем себя после завершения

func update_stripe_animation(progress: float):
	# Анимируем появление/исчезновение полосы
	stripe_rect.modulate.a = progress
	night_label.modulate.a = progress
	
	# Небольшое дрожание текста для атмосферности
	night_label.position.y = get_viewport().size.y / 2 - 50 + sin(Time.get_ticks_msec() * 0.01) * 2 * progress

func show_overlay():
	visible = true
	stripe_rect.visible = true
	night_label.visible = true

func hide_overlay():
	visible = false
	stripe_rect.visible = false
	night_label.visible = false
# Публичные методы для управления
func set_night_number(number: int):
	night_number = number
	if night_label:
		night_label.text = "NIGHT %d" % night_number

func set_reverse_delay(delay: float):
	reverse_delay = delay

func set_reverse_animation(enabled: bool):
	reverse_animation = enabled

func restart_intro():
	if tween:
		tween.kill()
	start_night_intro()

# Обработка изменения размера окна
func _on_viewport_size_changed():
	if stripe_rect:
		stripe_rect.size = Vector2(get_viewport().size.x, stripe_height)
		stripe_rect.position = Vector2(0, get_viewport().size.y / 2 - stripe_height / 2)
	
	if night_label:
		night_label.size = Vector2(get_viewport().size.x, 100)
		night_label.position = Vector2(0, get_viewport().size.y / 2 - 50)

# Подключение сигнала изменения размера
func _enter_tree():
	get_viewport().connect("size_changed", Callable(self, "_on_viewport_size_changed"))

func _exit_tree():
	if get_viewport().size_changed.is_connected(Callable(self, "_on_viewport_size_changed")):
		get_viewport().size_changed.disconnect(Callable(self, "_on_viewport_size_changed"))
