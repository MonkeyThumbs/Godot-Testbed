extends Action


func enter(_tick: Tick) -> void:
	pass


func open(tick: Tick) -> void:
	if tick.blackboard.get("Risen") == null:
		tick.blackboard.set("Risen", false)
	if tick.blackboard.get("Risen") == false:
		owner.change_animation("rise")


func close(tick: Tick) -> void:
	tick.blackboard.set("Risen", true)


func exit(_tick: Tick) -> void:
	pass


func tick(tick: Tick) -> int:
	if tick.blackboard.get("Risen") == true:
		return OK
	owner.velocity.x = 0
	if  owner.get_node("AnimationPlayer").current_animation == "rise":
		if  owner.get_node("AnimationPlayer").is_playing():
			return ERR_BUSY
	
	return OK
