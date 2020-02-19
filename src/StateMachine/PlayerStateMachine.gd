extends StateMachine

func _ready():
	add_state("idle")
	add_state("run")
	add_state("jump")
	add_state("tumble")
	add_state("fall")
	add_state("land")
	add_state("couch")
	add_state("slide")
	add_state("stand")
	add_state("hurt")
	add_state("death")
	add_state("ledge_hang")
	add_state("ledge_climb")
	add_state("wall_slide")
	add_state("wall_jump")
	add_state("climb_down")
	add_state("climb_up")
	add_state("climb_idle")
	add_state("attack_heavy")
	add_state("attack_quick")
	add_state("attack_jump")
	add_state("attack_spin")
	add_state("armed_idle")
	add_state("cast")
	add_state("cast_loop")
	add_state("swim_foward")
	add_state("swim_idle")
	add_state("fly")
	call_deferred("set_state", states.idle)

func _state_logic(delta: float) -> void:
	pass

func _get_transition(delta : float):
	return null

func _enter_state(new_state, old_state) -> void:
	pass

func _exit_state(old_state, new_state) -> void:
	pass
