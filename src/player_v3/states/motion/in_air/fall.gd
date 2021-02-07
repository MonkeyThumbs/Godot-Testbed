extends Motion


var AIR_STEERING_POWER : float = 5 * Globals.UNIT_SIZE


func initialiaze(steering_power : float):
	AIR_STEERING_POWER = steering_power


func enter():
	var input_direction = get_input_direction()
	update_look_direction(input_direction)
	owner.change_animation("fall")
	owner.is_jumping = false


func update(delta):
	var input_direction = get_input_direction()
	
	if owner.check_is_on_ledge():
		var collider = owner.get_ledge_collider()
		var one_way : bool = false
		
		if collider is TileMap:
			var tile_set : TileSet = collider.tile_set
			var collision_point : Vector2 = owner.get_ledge_collision_point()
			var tile_coord : Vector2 = collision_point / collider.cell_size
			var tile_id : int = collider.get_cellv(tile_coord)
			var tile_shapes = tile_set.tile_get_shapes(tile_id)
			
			if tile_set.tile_get_tile_mode(tile_id) == TileSet.ATLAS_TILE:
				var subtile_coord : Vector2 = collider.get_cell_autotile_coord(int(tile_coord.x), int(tile_coord.y))
				for shape in tile_shapes:
					if shape["autotile_coord"] == subtile_coord and shape["one_way"] == true:
						one_way = true
						break
			else:
				var shape_count : int = tile_set.tile_get_shape_count(tile_id)
				for i in shape_count:
					if tile_set.tile_get_shape_one_way(tile_id, i):
						one_way = true
		
		if not one_way:
			emit_signal("finished","ledge_hang")
	elif owner.check_is_on_wall() && input_direction.x == get_look_direction().x:
		emit_signal("finished","wall_slide")
	elif owner.check_is_on_floor() or owner.velocity.y <= -Globals.SAFETY_MARGIN:
		emit_signal("finished", "idle")
	
	update_look_direction(input_direction)
	move_horizontally(delta, input_direction)


func move_horizontally(delta : float, direction : Vector2) -> void:
	owner.velocity.x = AIR_STEERING_POWER * direction.x
