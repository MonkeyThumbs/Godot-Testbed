extends Control

signal beginning
signal finished

export(float) var scene_fade_duration : float = 5.0
export(float) var text_fade_duration : float = 5.0

onready var fade_tween = $FadeTween
onready var fade_rect = $FadeRect
onready var game_over = $GameOver
onready var text_tween = $TextTween
onready var audio_player = $AudioStreamPlayer


func activate() -> void:
	self.visible = true
	fade_rect.set_visible(true)
	fade_tween.interpolate_property(fade_rect, "self_modulate", fade_rect.self_modulate, Color(0.0, 0.0, 0.0, 1.0), scene_fade_duration, Tween.TRANS_LINEAR, Tween.TRANS_QUINT)
	fade_tween.start()
	
	game_over.set_visible(true)
	game_over.set_self_modulate(Color(1,1,1,0))
	text_tween.interpolate_property(game_over, "self_modulate", game_over.get_self_modulate(), Color(1,1,1,1), text_fade_duration, Tween.TRANS_LINEAR, Tween.TRANS_QUINT)
	text_tween.start()
	
	audio_player.play()
	
	emit_signal("beginning")

func _on_health_depleted():
	activate()

func _on_FadeTween_tween_all_completed():
	emit_signal("finished")
