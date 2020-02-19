extends "on_ground.gd"

export(float) var MAX_WALK_SPEED = 8 * Globals.UNIT_SIZE
export(float) var MAX_RUN_SPEED = 12 * Globals.UNIT_SIZE

func enter():
	speed = 0.0
	velocity = Vector2.ZERO

	var input_direction = get_input_direction()
	update_look_direction(input_direction)
	owner.get_node("AnimationPlayer").play("walk")

func handle_input(event : InputEvent):
	return .handle_input(event)

func update(delta):
	var input_direction = get_input_direction()
	if not input_direction:
		emit_signal("finished", "idle")
	update_look_direction(input_direction)
	apply_gravity(delta)
	
	speed = MAX_RUN_SPEED if Input.is_action_pressed("run") else MAX_WALK_SPEED
	var collision_info = move(speed, input_direction)
	
	if velocity.y > Globals.SAFETY_MARGIN and not owner.is_on_floor():
		emit_signal("finished", "fall")
	
	if not collision_info:
		return
	if collision_info.collider.is_in_group("environment"):
		return null

func move(speed, direction):
	velocity.x = direction.normalized().x * speed
	velocity = owner.move_and_slide(velocity, Globals.UP, true, 10)
	if owner.get_slide_count() == 0:
		return
	return owner.get_slide_collision(0)
