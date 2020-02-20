extends Node

signal finished

export(float) var duration : float = 1.0

onready var fade_tween = $ParallaxBackground/ParallaxLayer/FadeRect/Tween
onready var fade_rect = $ParallaxBackground/ParallaxLayer/FadeRect

func _ready():
	fade_rect.visible = true
	fade_tween.interpolate_property(fade_rect, "color", fade_rect.color, Color(0.0, 0.0, 0.0, 0.0), duration, Tween.TRANS_LINEAR, Tween.TRANS_QUINT)
	fade_tween.start()


func _on_Tween_tween_all_completed():
	emit_signal("finished")
	
