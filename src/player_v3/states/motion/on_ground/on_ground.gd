extends "../motion.gd"


var speed = 0.0


func handle_input(event : InputEvent):
	if event.is_action_pressed("attack") && owner.check_is_on_floor():
		emit_signal("finished", "attack")
	return .handle_input(event)
