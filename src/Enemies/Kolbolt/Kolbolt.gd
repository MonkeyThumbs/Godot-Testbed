extends KinematicBody2D

var visible_bodies = []

signal direction_changed(new_direction)
signal health_changed(health, amount)
signal mana_changed(mana, amount)
signal health_depleted()

export(int) var slope_force :int = 1
export(float) var stun_duration : float = 0.1
export(Vector2) var snap_point : Vector2 = Vector2(0, 0)
export(float) var run_speed : float = 216.0 setget ,get_run_speed

var look_direction : Vector2 = Vector2(1, 0) setget set_look_direction, get_look_direction
var velocity = Vector2(0, 0)
var local_gravity : Vector2 = Vector2.DOWN setget set_local_gravity, get_local_gravity
var is_dead : bool = false
var is_stunned : bool = false
var stun_timer = 0

func _physics_process(delta):
	if !check_is_on_floor():
		apply_gravity(delta)
	
	velocity = move_and_slide_with_snap(velocity, snap_point, Globals.UP, true, slope_force, deg2rad(90), true)
	
	if not is_stunned:
		$BehaviorTree.tick(self, $BehaviorBlackboard)
	else:
		stun_timer += delta
		if stun_timer >= stun_duration:
			stun_timer = 0
			is_stunned = false


func take_damage(attacker : Node, amount : int, effect = null):
	if self.is_a_parent_of(attacker):
		return
	if not is_dead || is_stunned:
		change_animation("stagger")
		velocity = 180 * -(attacker.global_position - global_position).normalized()
		is_stunned = true
		$Health.take_damage(amount, effect)


func set_dead(value : bool):
	is_dead = value
	velocity.x = 0
	set_process_input(value)
	set_physics_process(value)
	$BehaviorTree.set_disabled(value)
	for shape in $Sprite/Hitbox.get_children():
		shape.call_deferred("set_disabled", true)
#	$CollisionShape2D.disabled = value


func set_look_direction(value):
	look_direction = value
	emit_signal("direction_changed", value)


func get_look_direction() -> Vector2:
	return look_direction


func update_look_direction(direction):
	if direction and get_look_direction() != direction:
		set_look_direction(direction)
	if not direction.x in [-1, 1]:
		return
	get_node("Sprite").set_scale(Vector2(direction.x, 1))


func apply_gravity(delta : float) -> void:
	velocity += Globals.gravity * local_gravity * delta


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


func check_for_edge() -> bool:
	return $Sprite/EdgeSensor.check_for_edge()


func set_local_gravity(gravity : Vector2) -> void:
	local_gravity = gravity


func get_local_gravity() -> Vector2:
	return local_gravity


func get_run_speed() -> float:
	return run_speed


func check_can_attack() -> bool:
	return $Sprite/AttackRangeSensor.check_attack_range()


func check_can_see_player() -> bool:
	var raycast := RayCast2D.new()
	for body in visible_bodies:
		if body.is_in_group("player"):
			raycast.set_cast_to(body.get_position() - self.get_position())
			if raycast.is_colliding():
				var dif = raycast.get_collision_point() - self.get_position()
				if dif < raycast.get_cast_to():
					return false
			return true
	return false



func _on_LineOfSight_body_entered(body):
	visible_bodies.append(body)


func _on_LineOfSight_body_exited(body):
	var index = visible_bodies.find(body)
	if index != -1: visible_bodies.remove(index)


func _on_health_depleted():
	change_animation("die")
	emit_signal("health_depleted")
	set_dead(true)


func _on_health_changed(health, amount):
	emit_signal("health_changed", health, amount)
	$Sprite/BloodSplatter.set_emitting(true)
