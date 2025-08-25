extends CanvasLayer

class_name CombinedNightIntro

@export_group("First Animation (Split)")
@export var first_wait_duration: float = 0.5
@export var first_split_duration: float = 2.0
@export var first_hold_duration: float = 0.5

@export_group("Second Animation (Merge)")
@export var delay_between_animations: float = 5.0
@export var second_wait_duration: float = 0.5
@export var second_split_duration: float = 2.0
@export var second_hold_duration: float = 1.0

var top_rect: ColorRect
var bottom_rect: ColorRect
var tween: Tween

func _ready():
	start_combined_animation()

func start_combined_animation():
	# Первая анимация: разделение
	await play_first_animation_split()
	
	# Ждём 5 секунд между анимациями
	await get_tree().create_timer(delay_between_animations).timeout
	
	# Вторая анимация: соединение
	await play_second_animation_merge()
	
	# Завершаем
	queue_free()

func play_first_animation_split():
	# Создаём полный чёрный экран
	create_black_screen()
	
	# Ждём перед началом анимации
	await get_tree().create_timer(first_wait_duration).timeout
	
	# Анимация разделения
	tween = create_tween()
	tween.set_parallel(true)
	
	# Верхняя часть уезжает вверх
	tween.tween_property(top_rect, "position:y", 
						-get_viewport().size.y / 2, 
						first_split_duration).set_ease(Tween.EASE_OUT)
	
	# Нижняя часть уезжает вниз
	tween.tween_property(bottom_rect, "position:y", 
						get_viewport().size.y, 
						first_split_duration).set_ease(Tween.EASE_OUT)
	
	await tween.finished
	await get_tree().create_timer(first_hold_duration).timeout
	
	# Удаляем элементы первой анимации
	if top_rect:
		top_rect.queue_free()
	if bottom_rect:
		bottom_rect.queue_free()

func play_second_animation_merge():
	# Создаём разделённый экран
	create_split_screen()
	
	# Ждём перед началом анимации
	await get_tree().create_timer(second_wait_duration).timeout
	
	# Анимация соединения
	tween = create_tween()
	tween.set_parallel(true)
	
	# Верхняя часть приезжает сверху
	tween.tween_property(top_rect, "position:y", 
						0, 
						second_split_duration).set_ease(Tween.EASE_OUT)
	
	# Нижняя часть приезжает снизу
	tween.tween_property(bottom_rect, "position:y", 
						get_viewport().size.y / 2, 
						second_split_duration).set_ease(Tween.EASE_OUT)
	
	await tween.finished
	await get_tree().create_timer(second_hold_duration).timeout

func create_black_screen():
	# Полный чёрный экран для первой анимации
	top_rect = ColorRect.new()
	top_rect.name = "TopBlackRect"
	top_rect.color = Color.BLACK
	top_rect.size = Vector2(get_viewport().size.x, get_viewport().size.y / 2)
	top_rect.position = Vector2(0, 0)
	add_child(top_rect)
	
	bottom_rect = ColorRect.new()
	bottom_rect.name = "BottomBlackRect"
	bottom_rect.color = Color.BLACK
	bottom_rect.size = Vector2(get_viewport().size.x, get_viewport().size.y / 2)
	bottom_rect.position = Vector2(0, get_viewport().size.y / 2)
	add_child(bottom_rect)

func create_split_screen():
	# Разделённый экран для второй анимации
	top_rect = ColorRect.new()
	top_rect.name = "TopBlackRect2"
	top_rect.color = Color.BLACK
	top_rect.size = Vector2(get_viewport().size.x, get_viewport().size.y / 2)
	top_rect.position = Vector2(0, -get_viewport().size.y / 2)
	add_child(top_rect)
	
	bottom_rect = ColorRect.new()
	bottom_rect.name = "BottomBlackRect2"
	bottom_rect.color = Color.BLACK
	bottom_rect.size = Vector2(get_viewport().size.x, get_viewport().size.y / 2)
	bottom_rect.position = Vector2(0, get_viewport().size.y)
	add_child(bottom_rect)
