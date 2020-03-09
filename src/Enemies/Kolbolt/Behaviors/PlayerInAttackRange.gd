extends "res://addons/godot-behavior-tree-plugin/condition.gd"

func tick(_tick: Tick) -> int:
	if owner.check_can_attack():
		return OK
	return FAILED
