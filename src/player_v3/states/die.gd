extends State


# Initialize the state. E.g. change the animation
func enter():
	owner.change_animation("die")
	owner.set_dead(true)

func handle_input(event):
	return

func _on_animation_finished(anim_name):
	return
#	emit_signal("finished", "dead")
