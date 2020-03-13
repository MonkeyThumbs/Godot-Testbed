extends Action


func enter(_tick: Tick) -> void:
	pass

func open(_tick: Tick) -> void:
	owner.change_animation("rise")

func close(_tick: Tick) -> void:
	pass

func exit(_tick: Tick) -> void:
	pass

func tick(_tick: Tick) -> int:
	if owner.get_node("AnimationPlayer").is_playing():
		return ERR_BUSY
	return OK
