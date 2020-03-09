extends "res://addons/godot-behavior-tree-plugin/action.gd"

func tick(_tick: Tick) -> int:
	owner.change_animation("walk")
	owner.velocity.x = owner.get_look_direction().normalized().x * owner.get_run_speed()
	if owner.check_for_edge() || owner.check_is_infront_of_wall() || owner.check_is_on_ledge():
		return FAILED
	if not owner.check_can_see_player():
		owner.velocity.x = 0
		owner.update_look_direction(-owner.get_look_direction())
		return FAILED
	return OK if owner.check_can_attack() else ERR_BUSY
