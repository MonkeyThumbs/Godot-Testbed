extends "on_ground.gd"


export(float) var MAX_WALK_SPEED = 10 * Globals.UNIT_SIZE
export(float) var MAX_RUN_SPEED = 12 * Globals.UNIT_SIZE


func enter():
	speed = 0.0
	owner.velocity = Vector2.ZERO
	
	var input_direction = get_input_direction()
	update_look_direction(input_direction)
	owner.change_animation("walk")


func handle_input(event : InputEvent):
	if event.is_action_pressed("jump") && owner.check_is_on_floor():
		emit_signal("finished", "tumble")
	return .handle_input(event)


func update(delta):
	var input_direction = get_input_direction()
	if not input_direction.x:
		emit_signal("finished", "idle")
	elif input_direction.y > 0:
		emit_signal("finished", "crouch")
	update_look_direction(input_direction)
	
	var collision_info = move(speed, input_direction)
	
	if owner.velocity.y > Globals.SAFETY_MARGIN && !owner.check_is_on_floor():
		emit_signal("finished", "fall")
	
	return .update(delta)


func move(speed, direction):
	speed =  MAX_RUN_SPEED if Input.is_action_pressed("run") else MAX_WALK_SPEED
	owner.velocity.x = direction.normalized().x * speed
	if owner.get_slide_count() == 0:
		return
	return owner.get_slide_collision(0)
