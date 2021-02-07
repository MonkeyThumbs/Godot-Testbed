extends Motion

func enter() -> void:
	owner.change_animation("ledge_hang")
	owner.set_local_gravity(Vector2(0.0, 0.0))
	owner.velocity = Vector2(0.0, 0.0)
	var wall = owner.get_ledge_collider()
	if wall is TileMap:
		var position_wall : int = int(wall.position.y)
		var tile_size : int = wall.cell_size.y
		var collision_point : int = int(owner.get_ledge_collision_point().y)
		var tile_count : int = collision_point / tile_size
		var position_cell : int = position_wall + tile_count * tile_size
		var position_difference : int = position_cell - collision_point
		owner.position.y += position_difference


func exit() -> void:
	owner.set_local_gravity(Vector2.DOWN)


func handle_input(event : InputEvent) -> void:
	if event.is_action_pressed("jump"):
		emit_signal("finished", "fall")
	elif event.is_action_pressed("move_up"):
		emit_signal("finished", "ledge_climb")


func update(delta : float) -> void:
	var input_direction = get_input_direction()
	if input_direction.x != 0.0 && input_direction != get_look_direction():
		emit_signal("finished", "fall")
		update_look_direction(input_direction)
