extends "res://addons/godot-behavior-tree-plugin/action.gd"

func enter(tick: Tick) -> void:
	owner.velocity.x = 0
	owner.update_look_direction(-owner.get_look_direction())

func open(tick: Tick) -> void:
	pass

func close(tick: Tick) -> void:
	pass

func exit(tick: Tick) -> void:
	pass

func tick(_tick: Tick) -> int:
	return OK
