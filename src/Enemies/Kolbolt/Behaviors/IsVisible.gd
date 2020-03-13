extends Condition

func tick(_tick: Tick) -> int:
	if owner.get_node("VisibilityNotifier2D").is_on_screen():
		return OK
	return FAILED
