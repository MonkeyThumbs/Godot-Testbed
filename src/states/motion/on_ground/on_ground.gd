extends "../motion.gd"

var speed = 0.0

func handle_input(event : InputEvent):
	if event.is_action_pressed("jump") && owner.is_on_floor():
		emit_signal("finished", "jump")
	return .handle_input(event)
