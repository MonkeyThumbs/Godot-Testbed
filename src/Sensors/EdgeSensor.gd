extends Node

func check_for_edge() -> bool:
	return !$RayCast2D.is_colliding()
