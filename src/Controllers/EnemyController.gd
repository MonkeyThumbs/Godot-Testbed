class_name EnemyController
extends MobController

var visible_bodies = []

export(float) var stun_duration : float = 0.1

func _physics_process(delta):
	._physics_process(delta)
	if not is_stunned:
		$BehaviorTree.tick(self, $BehaviorBlackboard)
	else:
		stun_timer += delta
		if stun_timer >= stun_duration:
			stun_timer = 0
			is_stunned = false


func set_dead(value : bool):
	.set_dead(value)
	$BehaviorTree.set_disabled(value)


func check_for_edge() -> bool:
	return $Sprite/EdgeSensor.check_for_edge()


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

func get_player_position() -> Vector2:
	var player = null
	for body in visible_bodies:
		if body.is_in_group("player"):
			player = body
			break
	return player

func _on_LineOfSight_body_entered(body):
	visible_bodies.append(body)


func _on_LineOfSight_body_exited(body):
	var index = visible_bodies.find(body)
	if index != -1: visible_bodies.remove(index)
