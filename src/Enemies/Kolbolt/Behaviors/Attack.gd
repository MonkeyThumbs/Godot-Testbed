extends "res://addons/godot-behavior-tree-plugin/action.gd"

onready var done : bool = false

func enter(tick: Tick) -> void:
	pass

func open(tick: Tick) -> void:
	owner.velocity.x = 0
	owner.change_animation("attack")

func close(tick: Tick) -> void:
	pass

func exit(tick: Tick) -> void:
	pass

func tick(_tick: Tick) -> int:
	if not owner.check_can_see_player():
#		owner.velocity.x = 0
		owner.update_look_direction(-owner.get_look_direction())
		return FAILED
	return OK if done else ERR_BUSY


func _on_AnimationPlayer_animation_finished(anim_name):
	done = true
