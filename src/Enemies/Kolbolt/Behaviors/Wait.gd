extends Action

func enter(tick: Tick) -> void:
	pass

func open(tick: Tick) -> void:
	owner.velocity.x = 0
	owner.change_animation("idle")

func close(tick: Tick) -> void:
	pass

func exit(tick: Tick) -> void:
	pass

func tick(_tick: Tick) -> int:
	return OK if owner.get_node("IdleTimer").time_left <= 0 else ERR_BUSY
