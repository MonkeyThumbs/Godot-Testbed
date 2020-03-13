class_name OnGround
extends Motion

var speed = 0.0


func update(delta : float):
	if Input.is_action_pressed("attack") && owner.check_is_on_floor():
		emit_signal("finished", "attack")
	if Input.is_action_pressed("cast") && owner.check_is_on_floor():
		emit_signal("finished", "cast")
