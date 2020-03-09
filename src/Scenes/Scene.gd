class_name Scene
extends Node2D

onready var main_menu := $GUI/MainMenu

func _ready():
	get_tree().set_pause(false)
	main_menu.connect("visible_changed", self, "_on_MainMenu_visible_changed")


func _exit_tree():
	main_menu.disconnect("visible_changed", self, "_on_MainMenu_visible_changed")

# warning-ignore:unused_argument
func _handle_input(event : InputEvent) -> void:
	pass


func _on_MainMenu_open() -> void:
	pass


func _on_MainMenu_close() -> void:
	pass


func _unhandled_input(event : InputEvent):
	_handle_input(event)
	if event.is_action_pressed("fullscreen_toggle"):
		OS.set_window_fullscreen(!OS.is_window_fullscreen())


func _on_MainMenu_visible_changed(visibility : bool):
	if visibility: _on_MainMenu_open()
	else:		   _on_MainMenu_close()
