extends Motion

func enter() -> void:
	owner.change_animation("ledge_climb")
	owner.set_local_gravity(Vector2(0.0, 0.0))
	owner.velocity = Vector2(0.0, 0.0)


func exit() -> void:
	owner.velocity.y = 0
	owner.set_position(owner.get_position() + Vector2(12, 0) * owner.get_look_direction())
	owner.set_local_gravity(Vector2.DOWN)


#func update(delta :float):
#	owner.velocity.y = -95


func _on_animation_finished(anime_name : String):
	if anime_name == "ledge_climb":
		emit_signal("finished", "idle")
