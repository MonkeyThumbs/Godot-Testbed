extends "../motion.gd"

export(float) var AIR_STEERING_POWER = 8 * Globals.UNIT_SIZE
export(float) var MAX_JUMP_HEIGHT = 10.0 * Globals.UNIT_SIZE
export(float) var MIN_JUMP_HEIGHT = 0.8 * Globals.UNIT_SIZE
export(float) var JUMP_DURATION = 0.5

var gravity
var max_jump_velocity
var min_jump_velocity


func initialize(speed, _velocity):
	pass


func enter():
	max_jump_velocity = -sqrt(2 * MAX_JUMP_HEIGHT * Globals.gravity.y)
	min_jump_velocity = -sqrt(2 * MIN_JUMP_HEIGHT * Globals.gravity.y)
	
	if owner.is_on_floor():
		velocity.y = max_jump_velocity
	
	owner.get_node("AnimationPlayer").play("jump")


func update(delta):
	var input_direction = get_input_direction()
	update_look_direction(input_direction)
	move_horizontally(delta, input_direction)
	apply_gravity(delta)
	velocity = owner.move_and_slide(velocity, Globals.UP, true, 10)
	
	if velocity.y >= -Globals.SAFETY_MARGIN:
		emit_signal("finished", "fall")


func handle_input(event : InputEvent):
	if event.is_action_released("jump") && velocity.y < min_jump_velocity:
		velocity.y = min_jump_velocity
	.handle_input(event)


func move_horizontally(delta : float, direction : Vector2) -> void:
	velocity.x = AIR_STEERING_POWER * direction.x
