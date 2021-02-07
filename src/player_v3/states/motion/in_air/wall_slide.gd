extends Motion

func enter():
	owner.change_animation("wall_slide")
	owner.velocity.y = 0
	owner.set_local_gravity(Vector2.DOWN * 0.8)


func exit() -> void:
	owner.set_local_gravity(Vector2.DOWN)


func handle_input(event : InputEvent) -> void:
	if event.is_action_pressed("jump"):
		emit_signal("finished", "wall_jump")
	elif owner.velocity.y >= -Globals.SAFETY_MARGIN:
		emit_signal("finished", "fall")


func update(delta : float) -> void:
	var input_direction = get_input_direction()
	if input_direction != get_look_direction():
		emit_signal("finished", "fall")
		update_look_direction(input_direction)
	elif owner.check_is_on_floor():
		emit_signal("finished", "idle")
