extends State

var knockback_direction : Vector2 = Vector2.ZERO

func enter():
	owner.change_animation("stagger")


func update(delta):
	owner.velocity = Vector2(32, 32) * knockback_direction


func _on_animation_finished(anim_name):
	emit_signal("finished", "idle")
