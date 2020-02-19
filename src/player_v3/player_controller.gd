extends KinematicBody2D


signal direction_changed(new_direction)
signal state_changed(current_state)

export(float) var slope_force = 1
export(Vector2) var snap_point

var look_direction = Vector2(1, 0) setget set_look_direction
var velocity = Vector2(0, 0)
var is_jumping : bool = false


func _physics_process(delta):
	if !check_is_on_floor():
		apply_gravity(delta)
	
	if !is_jumping:
		velocity = move_and_slide_with_snap(velocity, snap_point, Globals.UP, true, slope_force, deg2rad(90), true)
	else:
		velocity = move_and_slide(velocity, Globals.UP, true, slope_force, deg2rad(90), true)
	
	$Label.set_text(str(velocity))


func take_damage(attacker, amount, effect=null):
	if self.is_a_parent_of(attacker):
		return
	$States/Stagger.knockback_direction = (attacker.global_position - global_position).normalized()
	$Health.take_damage(amount, effect)


func set_dead(value):
	set_process_input(not value)
	set_physics_process(not value)
	$CollisionPolygon2D.disabled = value


func set_look_direction(value):
	look_direction = value
	emit_signal("direction_changed", value)


func apply_gravity(delta : float) -> void:
	velocity += Globals.gravity * delta


func change_animation(name : String) -> void:
	$AnimationPlayer.play(name)


func check_is_on_floor() -> bool:
	return $FloorDetector.check_is_on_floor()


func _on_StateMachine_state_changed(states_stack):
	emit_signal("state_changed", states_stack)
