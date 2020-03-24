extends ColorRect

signal opened
signal closed

var _pages = []
var _page : int = 0

onready var tween := Tween.new()
onready var timer := Timer.new()
onready var finished := false

func _ready() -> void:
	var err := OK
	modulate.a = 0.0
	add_child(timer)
	add_child(tween)
	err = timer.connect("timeout", self, "_on_timer_timeout")
	err = tween.connect("tween_all_completed", self, "_on_tween_all_completed")
	tween.interpolate_property(self, "modulate", modulate, Color(1, 1, 1, 1), 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	emit_signal("opened")


func _exit_tree() -> void:
	timer.disconnect("timeout", self, "_on_timer_timeout")
	tween.disconnect("tween_all_completed", self, "_on_tween_all_completed")
	remove_child(timer)
	remove_child(tween)


func _on_timer_timeout() -> void:
	if _page >= _pages.size():
		finished = true
		tween.interpolate_property(self, "modulate", modulate, Color(1, 1, 1, 0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
		tween.start()
	else:
		_page += 1
		update_text()


func _on_tween_all_completed() -> void:
	if not finished:
		timer.start(3.0)
	else:
		emit_signal("closed")


func add_page(page : String) -> void:
	_pages.push_back(page)


func get_page(index : int) -> String:
	var page := ""
	if index < _pages.size():
		page = _pages[index]
	return page


func update_text() -> void:
	if _page < _pages.size():
		$MarginContainer/RichTextLabel.set_text(_pages[_page])
