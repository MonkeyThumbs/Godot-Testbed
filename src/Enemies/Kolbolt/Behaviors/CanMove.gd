extends "res://addons/godot-behavior-tree-plugin/condition.gd"

func tick(_tick: Tick) -> int:
	if owner.check_for_edge() || owner.check_is_infront_of_wall() || owner.check_is_on_ledge():
		return FAILED
	return OK
