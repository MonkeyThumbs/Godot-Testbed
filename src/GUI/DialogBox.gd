extends ColorRect

signal opened
signal closed

onready var tween := Tween.new()
onready var timer := Timer.new()
onready var finished := false

func _ready() -> void:
	modulate.a = 0.0
	add_child(timer)
	add_child(tween)
	timer.connect("timeout", self, "_on_timer_timeout")
	tween.connect("tween_all_completed", self, "_on_tween_all_completed")
	tween.interpolate_property(self, "modulate", modulate, Color(1, 1, 1, 1), 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	emit_signal("opened")


func _exit_tree() -> void:
	timer.disconnect("timeout", self, "_on_timer_timeout")
	tween.disconnect("tween_all_completed", self, "_on_tween_all_completed")
	remove_child(timer)
	remove_child(tween)


func _on_timer_timeout() -> void:
	finished = true
	tween.interpolate_property(self, "modulate", modulate, Color(1, 1, 1, 0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()


func _on_tween_all_completed() -> void:
	if not finished:
		timer.start(3.0)
	else:
		emit_signal("closed")
