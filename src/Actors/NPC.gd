extends Actor

export(float) var patience = 3.0
export(float) var stamina = 5.0

func _ready():
	randomize()
	var time = randf() * stamina
	$Stamina.start(time)
	$Patience.stop()

func _handle_move_input() -> void:
	if is_moving:
		velocity.x = lerp(velocity.x, move_speed * facing, _get_h_weight())

func _physics_process(delta):
	apply_gravity(delta)

func _get_h_weight() -> float:
	return 0.2 if is_on_floor() else 0.1

func _on_Patience_timeout():
	randomize()
	var turn = randi() % 100
	if turn >= 33:
		change_facing()
	
	is_moving = true
	
	var time = randf() * stamina
	$Stamina.start(time)
	$Patience.stop()

func _on_Stamina_timeout():
	velocity.x = 0
	is_moving = false
	$Patience.start(patience)
	$Stamina.stop()

func _on_Player_Detector_body_entered_back(body):
	if !body.is_in_group("Players"):
		return
	
	change_facing()
	velocity.x = 0
	is_moving = false
	$Stamina.stop()
	$Patience.stop()

func _on_Player_Detector_body_entered_front(body):
	if !body.is_in_group("Players"):
		change_facing()
		velocity.x = 0
		is_moving = true
		$Stamina.start(stamina * randf())
		$Patience.stop()
	else:
		velocity.x = 0
		is_moving = false
		$Stamina.stop()
		$Patience.stop()


func _on_Player_Detector_body_exited_back(body):
	if !body.is_in_group("Players"):
		return
	$Patience.start(patience)


func _on_Player_Detector_body_exited_front(body):
	if !body.is_in_group("Players"):
		return
	$Patience.start(patience)
