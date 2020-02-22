extends "../motion.gd"


var AIR_STEERING_POWER : float = 5 * Globals.UNIT_SIZE


func enter():
	var input_direction = get_input_direction()
	update_look_direction(input_direction)
	owner.change_animation("fall")
	owner.is_jumping = false


func update(delta):
	var input_direction = get_input_direction()
	update_look_direction(input_direction)
	move_horizontally(delta, input_direction)
	
	if owner.check_is_on_floor() or owner.velocity.y <= -Globals.SAFETY_MARGIN:
		emit_signal("finished", "idle")


func move_horizontally(delta : float, direction : Vector2) -> void:
	owner.velocity.x = AIR_STEERING_POWER * direction.x
