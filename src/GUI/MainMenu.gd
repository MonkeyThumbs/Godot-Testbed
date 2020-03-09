extends Control

signal visible_changed(visibility)

func _unhandled_input(event : InputEvent):
	if event.is_action_pressed("ui_cancel"):
		set_visible(!is_visible())
		emit_signal("visible_changed", is_visible())
		accept_event()


func _on_Button2_pressed():
	var err = get_tree().change_scene("res://src/Scenes/Town.tscn")
	if err:
		print(err)


func _on_Button3_pressed():
	var err = get_tree().change_scene("res://src/Scenes/Stages/StarterTown.tscn")
	if err:
		print(err)


func _on_Button4_pressed():
	var err = get_tree().change_scene("res://src/Scenes/Cemetery.tscn")
	if err:
		print(err)
