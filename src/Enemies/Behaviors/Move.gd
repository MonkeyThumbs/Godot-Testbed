extends "res://addons/godot-behavior-tree-plugin/action.gd"

func tick(tick: Tick) -> int:
	var state := OK
	owner.change_animation("walk")
	
	owner.velocity.x = owner.get_look_direction().normalized().x * owner.get_run_speed()
	if owner.check_for_edge() || owner.check_is_infront_of_wall() || owner.check_is_on_ledge():
		state = FAILED
	elif not owner.check_can_see_player():
		tick.blackboard.set("player_visible", false)
		owner.velocity.x = 0
		owner.update_look_direction(-owner.get_look_direction())
		state = FAILED
	elif not owner.check_can_attack():
		tick.blackboard.set("last_known_player_location", owner.get_player_position())
		state = ERR_BUSY
	else: 
		state = OK
	
	return state
