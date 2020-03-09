extends Control

export(Color) var progress_over_color := Color.white
export(Color) var progress_under_color := Color.gray
#export(float) var max_value : float = 10 setget _on_max_value_changed

onready var changed_tween = $UpdateTween
onready var progress_over = $ProgressOver
onready var progress_under = $ProgressUnder

func _ready():
	if Engine.editor_hint:
		set_tint_progress_over(progress_over_color)
		set_tint_progress_under(progress_under_color)
		_on_max_value_changed(1)
	if not Engine.editor_hint:
		set_tint_progress_over(progress_over_color)
		set_tint_progress_under(progress_under_color)
		_on_max_value_changed(1)


func _process(_delta):
	if Engine.editor_hint:
		set_tint_progress_over(progress_over_color)
		set_tint_progress_under(progress_under_color)
		_on_max_value_changed(1)
	if not Engine.editor_hint:
		pass


func _on_value_changed(value : float, amount : float) -> void:
	progress_over.set_value(value)
	changed_tween.interpolate_property(progress_under, "value", progress_under.value, value, 0.4, Tween.TRANS_SINE, Tween.EASE_IN)
	changed_tween.start()


func _on_max_value_changed(max_value : float) -> void:
	progress_over.max_value = max_value
	if progress_over.value > max_value:
		progress_over.value = max_value
	progress_under.max_value = max_value
	if progress_under.value > max_value:
		progress_under.value = max_value


func set_tint_progress_over(color : Color) -> void:
	progress_over.set_tint_progress(color)


func set_tint_progress_under(color : Color) -> void:
	progress_under.set_tint_progress(color)
