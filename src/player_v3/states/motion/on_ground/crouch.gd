extends OnGround

func enter():
	owner.change_animation("crouch")
	owner.velocity.x = 0

func exit():
	return

# warning-ignore:unused_argument
func handle_input(event):
	var input_direction = get_input_direction()
	if input_direction.y <= 0:
		emit_signal("finished", "idle")

# warning-ignore:unused_argument
func update(delta):
	return

# warning-ignore:unused_argument
func _on_animation_finished(anim_name):
	return

func get_state_machine():
	return owner.get_node("StateMachine")
