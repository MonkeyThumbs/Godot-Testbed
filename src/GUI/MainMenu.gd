extends Control

signal visible_changed(visibility)

var scene : String

func _unhandled_input(event : InputEvent):
	if event.is_action_pressed("ui_cancel"):
		set_visible(!is_visible())
		emit_signal("visible_changed", is_visible())
		accept_event()


func _on_Button2_pressed():
	$FadeOut.activate()
	scene = "res://src/Scenes/Town.tscn"


func _on_Button3_pressed():
	$FadeOut.activate()
	scene = "res://src/Scenes/Stages/StarterTown.tscn"


func _on_Button4_pressed():
	$FadeOut.activate()
	scene = "res://src/Scenes/Stages/GothicCastle.tscn"


func _on_FadeOut_finished():
	var err = get_tree().change_scene(scene)
	if err:
		print(err)
