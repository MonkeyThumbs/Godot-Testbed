extends "../state.gd"

func handle_input(event : InputEvent):
	return


func enter():
	owner.velocity.x = 0.0
	owner.change_animation("attack")


func _on_animation_finished(anime_name):
	emit_signal("finished", "idle")
