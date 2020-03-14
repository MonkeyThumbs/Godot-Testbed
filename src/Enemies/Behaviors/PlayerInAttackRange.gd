extends "res://addons/godot-behavior-tree-plugin/condition.gd"

func tick(tick: Tick) -> int:
	if owner.check_can_attack():
		tick.blackboard.set("player_visible", true)
		return OK
	return FAILED
