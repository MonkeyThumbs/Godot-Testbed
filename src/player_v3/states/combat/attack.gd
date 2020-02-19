extends "../state.gd"

func handle_input(event : InputEvent):
	return


func enter():
	owner.velocity.x = 0.0
	owner.change_animation("attack")


func _on_Sword_attack_finished():
	emit_signal("finished", "idle")
