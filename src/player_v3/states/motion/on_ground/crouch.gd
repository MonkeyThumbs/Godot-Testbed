extends OnGround

func enter():
	owner.change_animation("crouch")


# warning-ignore:unused_argument
func handle_input(event):
	var input_direction = get_input_direction()
	update_look_direction(input_direction)
	if input_direction.y <= 0:
		emit_signal("finished", "idle")
	elif event.is_action_pressed("jump") && owner.check_is_on_floor():
		emit_signal("finished", "jump")


func update(delta):
	owner.velocity.x = 0
	.update(delta)
