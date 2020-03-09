extends "res://addons/godot-behavior-tree-plugin/action.gd"

func enter(_tick: Tick) -> void:
	pass

func open(_tick: Tick) -> void:
	if owner.get_node("PatrolTimer").is_stopped():
		owner.get_node("PatrolTimer").start()
	elif owner.get_node("PatrolTimer").is_paused():
		owner.get_node("PatrolTimer").set_paused(false)

func close(_tick: Tick) -> void:
	pass

func exit(_tick: Tick) -> void:
	pass

func tick(_tick: Tick) -> int:
	owner.change_animation("walk")
	owner.velocity.x = owner.get_look_direction().normalized().x * owner.get_run_speed()
	if owner.get_node("PatrolTimer").time_left <= 0:
		owner.get_node("PatrolTimer").stop()
		owner.get_node("IdleTimer").start()
		return FAILED
	elif owner.check_for_edge() || owner.check_is_infront_of_wall() || owner.check_is_on_ledge():
		owner.get_node("PatrolTimer").set_paused(true)
		return FAILED
	return OK if owner.check_can_see_player() else ERR_BUSY
