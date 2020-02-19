extends "state.gd"


# Initialize the state. E.g. change the animation
func enter():
	owner.set_dead(true)
	owner.change_animation("die")

func _on_animation_finished(anim_name):
	emit_signal("finished", "dead")
