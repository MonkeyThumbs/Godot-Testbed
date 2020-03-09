extends Spell


export(float) var speed : float  = 600.0

onready var velocity : Vector2 = Vector2(speed * look_direction.x, 0.0)


func _physics_process(delta):
	self.position += velocity * delta


func _on_collide_body(_body : PhysicsBody2D):
	var explosion = load("res://src/Effects/Explosions/Explosion_01.tscn")
	var instance = explosion.instance()
	instance.position = self.global_position
	get_tree().get_root().add_child(instance)
	self.queue_free()


func _on_Timer_timeout():
	$Tween.interpolate_property(self, "self_modulate", self.self_modulate, Color(1,1,1,0), 0.4, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()


func _on_Tween_tween_all_completed():
	self.queue_free()


func _on_collide_area(_area : Area2D):
	var explosion = load("res://src/Effects/Explosions/Explosion_01.tscn")
	var instance = explosion.instance()
	instance.position = self.global_position
	get_tree().get_root().add_child(instance)
	self.queue_free()
