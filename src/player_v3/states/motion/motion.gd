# Collection of important methods to handle direction and animation
class_name Motion
extends State

func handle_input(event : InputEvent):
	if event.is_action_pressed("simulate_damage"):
		owner.take_damage(null, 5, Globals.STATUS_NONE)
		emit_signal("finished", "stagger")


func get_input_direction():
	var input_direction = Vector2()
	input_direction.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	input_direction.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	return input_direction


func get_look_direction() -> Vector2:
	return owner.get_look_direction()


func update_look_direction(direction):
	if direction and owner.get_look_direction() != direction:
		owner.set_look_direction(direction)
	if not direction.x in [-1, 1]:
		return
	owner.get_node("Sprite").set_scale(Vector2(direction.x, 1))
