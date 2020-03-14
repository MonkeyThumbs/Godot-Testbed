extends "res://addons/godot-behavior-tree-plugin/action.gd"

onready var is_done : bool = false

func enter(tick: Tick) -> void:
	pass

func open(tick: Tick) -> void:
	owner.change_animation("attack")

func close(tick: Tick) -> void:
	pass

func exit(tick: Tick) -> void:
	pass

func tick(tick: Tick) -> int:
	var state := OK
	if not owner.check_can_see_player():
		owner.update_look_direction(-owner.get_look_direction())
		state = FAILED
	elif not owner.check_can_attack():
		tick.blackboard.set("last_known_player_location", owner.get_player_position())
		state = ERR_BUSY
	elif not is_done:
		state = ERR_BUSY
	
	return state


func _on_AnimationPlayer_animation_finished(anim_name):
	is_done = true
