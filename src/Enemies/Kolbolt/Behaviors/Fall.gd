extends Action

func open(_tick: Tick) -> void:
	owner.change_animation("die")
	
	if owner.get_node("IdleTimer").is_stopped():
		owner.get_node("IdleTimer").start()
	elif owner.get_node("IdleTimer").is_paused():
		owner.get_node("IdleTimer").set_paused(false)

func tick(_tick: Tick) -> int:
	owner.velocity.x = 0
	if owner.get_node("IdleTimer").time_left <= 0:
		owner.get_node("IdleTimer").stop()
		return OK
	elif owner.check_for_edge() || owner.check_is_infront_of_wall() || owner.check_is_on_ledge():
		owner.get_node("IdleTimer").set_paused(true)
		return FAILED
	return ERR_BUSY
