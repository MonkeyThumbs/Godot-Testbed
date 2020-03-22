extends "../motion.gd"

func enter() -> void:
	owner.velocity = Vector2.ZERO
	owner.change_animation("ledge_hang")
	owner.set_local_gravity(Vector2(0.0, 0.0))
	owner.velocity = Vector2(0.0, 0.0)


func exit() -> void:
	owner.set_local_gravity(Vector2.DOWN)

func handle_input(event : InputEvent) -> void:
	if event.is_action_pressed("jump"):
		emit_signal("finished", "fall")
	elif event.is_action_pressed("move_up"):
		emit_signal("finished", "ledge_climb")


func update(delta : float) -> void:
	var input_direction = get_input_direction()
	if input_direction.x != 0.0 && input_direction != get_look_direction():
		emit_signal("finished", "fall")
		update_look_direction(input_direction)
