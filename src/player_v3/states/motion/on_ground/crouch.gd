extends OnGround

func enter():
	owner.change_animation("crouch")


# warning-ignore:unused_argument
func handle_input(event):
	var input_direction = get_input_direction()
	update_look_direction(input_direction)
	if input_direction.y <= 0:
		emit_signal("finished", "idle")


func update(delta):
	owner.velocity.x = 0
	.update(delta)
