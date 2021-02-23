# Collection of important methods to handle direction and animation
class_name Motion
extends State


func get_input_direction():
	var input_direction = Vector2()
	input_direction.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	input_direction.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	return input_direction

func update(delta : float):
	if Input.is_action_just_pressed("skill_next"):
		owner.next_spell()
	if Input.is_action_just_pressed("skill_prev"):
		owner.prev_spell()


func get_look_direction() -> Vector2:
	return owner.get_look_direction()


func update_look_direction(direction):
	if direction and owner.get_look_direction() != direction:
		if direction.x:
			owner.set_look_direction(direction)
	if not direction.x in [-1, 1]:
		return
	owner.get_node("Sprite").set_scale(Vector2(direction.x, 1))
