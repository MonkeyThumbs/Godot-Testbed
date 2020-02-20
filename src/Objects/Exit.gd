extends Area2D

export(String, FILE, "*.tscn") var new_scene : String
export(Vector2) var entrance_position : Vector2

onready var is_waiting : bool = true


func _on_FadeOut_finished():
	Globals.entrance_position = entrance_position
	get_tree().change_scene(new_scene)


func _on_Timer_timeout():
	is_waiting = false


func _on_Exit_body_entered(body):
	$FadeOut.activate()
