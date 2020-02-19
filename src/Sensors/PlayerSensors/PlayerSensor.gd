extends Node2D

signal body_entered_front
signal body_entered_back
signal body_exited_front
signal body_exited_back


func _on_Front_body_entered(body):
	emit_signal("body_entered_front", body)


func _on_Front_body_exited(body):
	emit_signal("body_exited_front", body)


func _on_Back_body_entered(body):
	emit_signal("body_entered_back", body)


func _on_Back_body_exited(body):
	emit_signal("body_exited_back", body)
