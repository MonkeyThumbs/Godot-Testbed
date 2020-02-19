extends "../motion.gd"

export(float) var AIR_STEERING_POWER = 5 * Globals.UNIT_SIZE

func enter():
	var input_direction = get_input_direction()
	update_look_direction(input_direction)

	owner.get_node("AnimationPlayer").play("fall")

# Clean up the state. Reinitialize values like a timer
func update(delta):
	var direction = get_input_direction()
	move_horizontally(delta, direction)
	apply_gravity(delta)
	velocity = owner.move_and_slide(velocity, Globals.UP, true, 10)
	
	if owner.is_on_floor() or velocity.y <= -Globals.SAFETY_MARGIN:
		emit_signal("finished", "idle")
		
func move_horizontally(delta : float, direction : Vector2) -> void:
	velocity.x = AIR_STEERING_POWER * direction.x
