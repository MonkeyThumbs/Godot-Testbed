extends KinematicBody2D

enum SPELLS {
	FIREBOLT,
	LIGHTNING,
	HEAL,
}

signal direction_changed(new_direction)
signal state_changed(current_state)
signal health_changed(health, amount)
signal mana_changed(mana, amount)
signal max_health_changed(health)
signal max_mana_changed(mana)
signal mana_depleted
signal health_depleted


export(int) var slope_force :int = 1
export(Vector2) var snap_point : Vector2 = Vector2(0, 0)
export(SPELLS) var current_spell = SPELLS.FIREBOLT


var look_direction : Vector2 = Vector2(1, 0) setget set_look_direction, get_look_direction
var velocity = Vector2(0, 0)
var local_gravity : Vector2 = Vector2.DOWN setget set_local_gravity, get_local_gravity
var is_jumping : bool = false


func _physics_process(delta):
	if !check_is_on_floor():
		apply_gravity(delta)
	
	if !is_jumping:
		velocity = move_and_slide_with_snap(velocity, snap_point, Globals.UP, true, slope_force, deg2rad(90), true)
	else:
		velocity = move_and_slide(velocity, Globals.UP, true, slope_force, deg2rad(90), true)


func take_damage(attacker : Node, amount : int, effect = null):
#	if self.is_a_parent_of(attacker):
#		return
	$StateMachine/Stagger.knockback_direction = (attacker.global_position - global_position).normalized()
	$StateMachine._change_state("stagger")
	$Health.take_damage(amount, effect)


func set_dead(value):
	set_process_input(value)
	set_physics_process(value)
	$StateMachine.set_active(false)
	$Sprite/Hitbox/CollisionShape2D.set_disabled(true)
	emit_signal("health_depleted")
#	$CollisionShape2D.disabled = value


func set_look_direction(value):
	look_direction = value
	emit_signal("direction_changed", value)


func get_look_direction() -> Vector2:
	return look_direction


func apply_gravity(delta : float) -> void:
	velocity += Globals.gravity * local_gravity * delta


func change_animation(name : String) -> void:
	$AnimationPlayer.play(name)


func check_is_on_floor() -> bool:
	return $Sprite/FloorDetector.check_is_on_floor()


func check_is_on_wall() -> bool:
	return $Sprite/WallSensor.check_is_on_wall()


func check_is_on_ledge() -> bool:
	return $Sprite/WallSensor.check_is_on_ledge()


func play_sound(node_path : NodePath) -> bool:
	var success := false
	
	var sound := $SoundFX.get_node(node_path)
	if sound != null:
		sound.play()
		success = true
	
	return success


func stop_sound(node_path : NodePath) -> bool:
	var success := false
	
	var sound := $SoundFX.get_node(node_path)
	if sound != null:
		sound.stop()
		success = true
	
	return success



func set_local_gravity(gravity : Vector2) -> void:
	local_gravity = gravity


func get_local_gravity() -> Vector2:
	return local_gravity


func get_health() -> int:
	return $Health.get_health()


func get_max_health() -> int:
	return $Health.get_max_health()


func set_max_health(value : int) -> void:
	$Health.set_max_health(value)


func _on_StateMachine_state_changed(states_stack):
	emit_signal("state_changed", states_stack)


func _on_Health_health_changed(health, amount):
	$Sprite/BloodSplatter.set_emitting(true)
	emit_signal("health_changed", health, amount)
