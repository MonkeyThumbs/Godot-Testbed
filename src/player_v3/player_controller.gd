class_name Player
extends KinematicBody2D

#enum SPELLS {
#	FIREBOLT,
#	LIGHTNING,
#	HEAL,
#}

signal direction_changed(new_direction)
signal state_changed(current_state)
signal health_changed(health, amount)
signal current_spell_changed(prev, current)
# warning-ignore:unused_signal
signal mana_changed(mana, amount)
# warning-ignore:unused_signal
signal max_health_changed(health)
# warning-ignore:unused_signal
signal max_mana_changed(mana)
# warning-ignore:unused_signal
signal mana_depleted
signal health_depleted


export(int) var slope_force :int = 1
export(Vector2) var snap_point : Vector2 = Vector2(0, 0)


var look_direction : Vector2 = Vector2(1, 0) setget set_look_direction, get_look_direction
var velocity = Vector2(0, 0) setget set_velocity, get_velocity
var local_gravity : Vector2 = Vector2.DOWN setget set_local_gravity, get_local_gravity
var is_jumping : bool = false
var known_spells = [Spells.FIREBOLT, Spells.LIGHTNING, Spells.HEAL]
var current_spell = 0 setget set_current_spell, get_current_spell


func _physics_process(delta):
	if !check_is_on_floor():
		apply_gravity(delta)
	clamp_velocity()
	if !is_jumping:
		velocity = move_and_slide_with_snap(velocity, snap_point, Globals.UP, true, slope_force, deg2rad(90), true)
	else:
		velocity = move_and_slide(velocity, Globals.UP, true, slope_force, deg2rad(90), true)


func take_damage(attacker : Node, amount : int, effect = null):
	if self.is_a_parent_of(attacker):
		return
	$StateMachine/Stagger.knockback_direction = -(attacker.global_position - global_position).normalized()
	$StateMachine._change_state("stagger")
	$Health.take_damage(amount, effect)


func set_dead(value):
	set_process_input(value)
	set_physics_process(value)
	$StateMachine.set_active(false)
	$Sprite/Hitbox/CollisionShape2D.set_disabled(true)
	emit_signal("health_depleted")



func set_velocity(vel : Vector2):
	velocity = vel


func get_velocity() -> Vector2:
	return velocity


func set_look_direction(value):
	look_direction = value
	emit_signal("direction_changed", value)


func get_look_direction() -> Vector2:
	return look_direction


func apply_gravity(delta : float) -> void:
	velocity += Globals.gravity * local_gravity * delta


func clamp_velocity() -> void:
	velocity.x = clamp(velocity.x, -Globals.MAX_VELOCITY.x, Globals.MAX_VELOCITY.x)
	velocity.y = clamp(velocity.y, -Globals.MAX_VELOCITY.y, Globals.MAX_VELOCITY.y)


func change_animation(name : String) -> void:
	$AnimationPlayer.play(name)


#func change_animation(name : String) -> void:
#	$AnimationPlayer/AnimationTree.get("parameters/playback").travel(name)


func check_is_on_floor() -> bool:
	return $Sprite/FloorDetector.check_is_on_floor()


func check_is_on_wall() -> bool:
	return $Sprite/WallSensor.check_is_on_wall()


func check_is_on_ledge() -> bool:
	return $Sprite/WallSensor.check_is_on_ledge()


func get_floor_collider() -> Object:
	return $Sprite/FloorDetector.get_collider()


func get_wall_collider() -> Object:
	return $Sprite/WallSensor.get_wall_collider()


func get_ledge_collider() -> Object:
	return $Sprite/WallSensor.get_ledge_collider()


func get_wall_collision_point() -> Vector2:
	return $Sprite/WallSensor.get_wall_collision_point()


func get_ledge_collision_point() -> Vector2:
	return $Sprite/WallSensor.get_ledge_collision_point()


func get_ledge_sensor_position() -> Vector2:
	return $Sprite/WallSensor.get_ledge_sensor_position()


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


func get_current_spell() -> int:
	return current_spell


func set_current_spell(index : int):
	if known_spells.size() <= 0:
		return
	elif index >= known_spells.size():
		index = 0
	elif index < 0:
		index = known_spells.size() - 1
	
	var prev = current_spell
	current_spell = index
	
	emit_signal("current_spell_changed", prev, current_spell)


func next_spell():
	set_current_spell(get_current_spell() + 1)


func prev_spell():
	set_current_spell(get_current_spell() - 1)


func add_spell(id : int) -> bool:
	if not known_spells.has(id):
		known_spells.push_back(id)
		known_spells.sort()
		return true
	return false


func remove_spell(id : int) -> bool:
	if known_spells.has(id):
		known_spells.erase(id)
		known_spells.sort()
		set_current_spell(get_current_spell())
		return true
	return false


func _on_StateMachine_state_changed(states_stack):
	emit_signal("state_changed", states_stack)


func _on_Health_health_changed(health, amount):
	$Sprite/BloodSplatter.set_emitting(true)
	emit_signal("health_changed", health, amount)

