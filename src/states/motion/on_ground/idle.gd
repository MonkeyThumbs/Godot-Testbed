extends "on_ground.gd"

func enter():
	owner.get_node("AnimationPlayer").play("idle")

func handle_input(event : InputEvent):
	return .handle_input(event)

func update(delta):
	var input_direction = get_input_direction()
	velocity. x = 0.0
	apply_gravity(delta)
	velocity = owner.move_and_slide(velocity, Globals.UP, true)
	
	if input_direction:
		emit_signal("finished", "move")
	
	if velocity.y > 0.0:
		emit_signal("finished", "fall")
