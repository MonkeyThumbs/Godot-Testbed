extends Area2D

signal scene_changed

export(String, FILE, "*.tscn") var new_scene : String
export(Vector2) var entrance_position : Vector2
export(bool) var reset_music : bool = false

onready var is_waiting : bool = true


func _on_FadeOut_finished():
	Globals.entrance_position = entrance_position
	get_tree().change_scene(new_scene)
	emit_signal("scene_changed", reset_music)


func _on_Timer_timeout():
	is_waiting = false


func _on_Exit_body_entered(body):
	if !is_waiting:
		$FadeOut.activate()
