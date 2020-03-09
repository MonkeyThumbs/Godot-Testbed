extends "./StateMachine.gd"

func _ready():
	add_state("idle")
	add_state("run")
	call_deferred("set_state", states.idle)

func _state_logic(delta: float) -> void:
	match state:
		states.idle:
			pass
		states.run:
			pass

func _get_transition(delta : float):
	match state:
		states.idle:
			if parent.velocity.x != 0.0:
				return states.run
		states.run:
			if parent.velocity.x == 0.0:
				return states.idle	
	return null

func _enter_state(new_state, old_state) -> void:
	match new_state:
		states.idle:
			parent.change_animation("Idle")
		states.run:
			parent.change_animation("Running")

func _exit_state(old_state, new_state) -> void:
	match old_state:
		states.idle:
			pass
