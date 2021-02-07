extends Node2D

func check_is_on_floor() -> bool:
	for ray in self.get_children():
		if ray.is_colliding():
			return true	
	return false


func get_collider() -> Object:
	for ray in self.get_children():
		if ray.is_colliding():
			return ray.get_collider()
	return null
