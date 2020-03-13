class_name MobController
extends KinematicBody2D

signal direction_changed(new_direction)
signal state_changed(current_state)
signal health_changed(health, amount)
signal mana_changed(mana, amount)
signal max_health_changed(health)
signal max_mana_changed(mana)
signal health_depleted
signal mana_depleted

export(int) var slope_force :int = 1
export(Vector2) var snap_point : Vector2 = Vector2(0, 0)
export(float) var run_speed : float = 216.0 setget ,get_run_speed

var look_direction : Vector2 = Vector2(1, 0) setget set_look_direction, get_look_direction
var velocity = Vector2(0, 0)
var knockback_force = Vector2(0, 0) setget set_knockback_force,  get_knockback_force
var local_gravity : Vector2 = Vector2.DOWN setget set_local_gravity, get_local_gravity
var is_dead : bool = false
var is_stunned : bool = false
var stun_timer : float = 0

var is_jumping : bool = false


func _physics_process(delta):
	if !check_is_on_floor():
		apply_gravity(delta)
	apply_knockback()
	update_knockback_force(delta)
	
	if !is_jumping:
		velocity = move_and_slide_with_snap(velocity, snap_point, Globals.UP, true, slope_force, deg2rad(90), true)
	else:
		velocity = move_and_slide(velocity, Globals.UP, true, slope_force, deg2rad(90), true)

func take_damage(attacker : Node, amount : int, effect = null):
	if self.is_a_parent_of(attacker):
		return
	if not is_dead || is_stunned:
		change_animation("stagger")
		set_knockback_force(32 * -(attacker.global_position - global_position).normalized())
		is_stunned = true
		$Health.take_damage(amount, effect)


func set_dead(value : bool):
	is_dead = value
	velocity.x = 0
	knockback_force = Vector2.ZERO
	set_process_input(value)
	set_physics_process(value)
	for shape in $Sprite/Hitbox.get_children():
		shape.call_deferred("set_disabled", value)
	for shape in $Sprite/DamageBox.get_children():
		shape.call_deferred("set_disabled", value)


func set_look_direction(value):
	look_direction = value
	emit_signal("direction_changed", value)


func get_look_direction() -> Vector2:
	return look_direction


func set_knockback_force(force : Vector2) -> void:
	knockback_force = force


func get_knockback_force() -> Vector2:
	return knockback_force

func update_look_direction(direction):
	if direction and get_look_direction() != direction:
		set_look_direction(direction)
	if not direction.x in [-1, 1]:
		return
	get_node("Sprite").set_scale(Vector2(direction.x, 1))


func apply_gravity(delta : float) -> void:
	velocity += Globals.gravity * local_gravity * delta


func apply_knockback() -> void:
	velocity += get_knockback_force()


func update_knockback_force(delta : float) -> void:
	if knockback_force.x > 0.0:
		knockback_force.x -= 240 * delta * knockback_force.normalized().x
	else:
		knockback_force.x = 0.0
		
	if knockback_force.y > 0.0:
		knockback_force.y -= 240 * delta * knockback_force.normalized().y
	else:
		knockback_force.y = 0.0
	
	print(knockback_force)


func change_animation(name : String) -> void:
	if not $AnimationPlayer.current_animation == name:
		$AnimationPlayer.play(name)


func check_is_on_floor() -> bool:
	return $Sprite/FloorSensor.check_is_on_floor()


func check_is_on_wall() -> bool:
	return $Sprite/WallSensor.check_is_on_wall()


func check_is_infront_of_wall() -> bool:
	return $Sprite/WallSensor.check_is_infront_of_wall()


func check_is_on_ledge() -> bool:
	return $Sprite/WallSensor.check_is_on_ledge()


func set_local_gravity(gravity : Vector2) -> void:
	local_gravity = gravity


func get_local_gravity() -> Vector2:
	return local_gravity


func get_run_speed() -> float:
	return run_speed



func _on_health_depleted():
	change_animation("die")
	emit_signal("health_depleted")
	set_dead(true)


func _on_health_changed(health, amount):
	emit_signal("health_changed", health, amount)
	$Sprite/BloodSplatter.set_emitting(true)
