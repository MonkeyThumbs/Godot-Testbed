extends Condition


func tick(_tick: Tick) -> int:
	return OK if owner.get_node("IdleTimer").time_left <= 0 else FAILED
