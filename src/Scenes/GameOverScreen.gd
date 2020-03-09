extends Node2D

export(float) var scene_fade_duration : float = 5.0
export(float) var text_fade_duration : float = 5.0

func activate() -> void:
	self.visible = true
	$FadeOut.duration = scene_fade_duration
	$FadeOut.activate()
	$FadeOut/GameOver.set_self_modulate(Color(1,1,1,0))
	$TextTween.interpolate_property($FadeOut/GameOver, "self_modulate", $FadeOut/GameOver.get_self_modulate(), Color(1,1,1,1), text_fade_duration, Tween.TRANS_LINEAR, Tween.TRANS_QUINT)
	$TextTween.start()

func _on_health_depleted():
	activate()
