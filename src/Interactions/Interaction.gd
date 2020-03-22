extends Node2D
class_name Interaction

signal interaction_start
signal interaction_stop


var _active : bool = false setget activate, is_active


func _enter() -> void:
	pass


func _exit() -> void:
	pass


func _handle_input(event : InputEvent) -> void:
	pass


func _update(delta : float) -> void:
	pass


func _unhandled_input(event : InputEvent) -> void:
	if _active: _handle_input(event)


func _process(delta : float) -> void:
	if _active: _update(delta)


func activate(value : bool) -> void:
	if not _active and _active != value:
		emit_signal("interaction_start")
		_enter()
	elif _active and _active != value:
		emit_signal("interaction_stop")
		_exit()
	_active = value


func is_active() -> bool:
	return _active
