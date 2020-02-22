extends CanvasLayer

signal finished

export(float) var duration : float = 1.0

onready var fade_tween = $FadeRect/Tween
onready var fade_rect = $FadeRect


func activate() -> void:
	fade_rect.set_visible(true)
	fade_tween.interpolate_property(fade_rect, "color", fade_rect.color, Color(0.0, 0.0, 0.0, 1.0), duration, Tween.TRANS_LINEAR, Tween.TRANS_QUINT)
	fade_tween.start()


func _on_Tween_tween_all_completed():
	emit_signal("finished")
