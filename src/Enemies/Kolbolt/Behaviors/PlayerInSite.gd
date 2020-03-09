extends "res://addons/godot-behavior-tree-plugin/condition.gd"

func tick(_tick: Tick) -> int:
	if owner.check_can_see_player(): 
		return OK
	return FAILED
