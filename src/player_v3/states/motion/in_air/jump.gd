extends "../motion.gd"

export(float) var AIR_STEERING_POWER = 4.0 * Globals.UNIT_SIZE
export(float) var MAX_JUMP_HEIGHT = 5.0 * Globals.UNIT_SIZE
export(float) var MIN_JUMP_HEIGHT = 0.8 * Globals.UNIT_SIZE
export(float) var JUMP_DURATION = 0.5

onready var max_jump_velocity = -sqrt(2 * MAX_JUMP_HEIGHT * Globals.gravity.y)
onready var min_jump_velocity = -sqrt(2 * MIN_JUMP_HEIGHT * Globals.gravity.y)

func enter():
	owner.change_animation("jump")
	owner.velocity.y = max_jump_velocity

func update(delta):
	var input_direction = get_input_direction()
	update_look_direction(input_direction)
	move_horizontally(delta, input_direction)
	
	if owner.velocity.y >= -Globals.SAFETY_MARGIN:
		emit_signal("finished", "fall")


func handle_input(event : InputEvent):
	if event.is_action_released("jump") && owner.velocity.y < min_jump_velocity:
		owner.velocity.y = min_jump_velocity
	.handle_input(event)


func move_horizontally(delta : float, direction : Vector2) -> void:
	owner.velocity.x = AIR_STEERING_POWER * direction.x
