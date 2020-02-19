extends "on_ground.gd"

func enter():
	owner.change_animation("idle")

func handle_input(event : InputEvent):
	if event.is_action_pressed("jump") && owner.check_is_on_floor():
		emit_signal("finished", "jump")
	return .handle_input(event)

func update(delta):
	var input_direction = get_input_direction()
		
	if input_direction:
		emit_signal("finished", "move")
	
	if owner.velocity.y > 0.0 && !owner.check_is_on_floor():
		emit_signal("finished", "fall")
