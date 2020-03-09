extends "../state.gd"

func enter():
	owner.change_animation("cast_loop")


func exit():
	owner.get_node("Spells/Persistant/Lightning").queue_free()


func handle_input(event : InputEvent):
	if event.is_action_released("cast"):
		emit_signal("finished", "idle")
#		owner.get_node("Spells/Persistant/Lightning").queue_free()
