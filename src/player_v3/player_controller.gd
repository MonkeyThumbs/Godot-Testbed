extends KinematicBody2D


signal direction_changed(new_direction)
signal state_changed(current_state)

export(float) var slope_force = 4.0

var look_direction = Vector2(1, 0) setget set_look_direction
var velocity = Vector2()


func _physics_process(delta):
	self.apply_gravity(delta)
	velocity = self.move_and_slide(velocity, Globals.UP, true)


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
