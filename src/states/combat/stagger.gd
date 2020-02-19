extends "../motion/motion.gd"

var knockback_direction = Vector2()

func enter():
	owner.get_node("AnimationPlayer").play("stagger")


func _process(delta):
	apply_gravity(delta)
	velocity = owner.move_and_slide(velocity, Globals.UP, true)


func _on_animation_finished(anim_name):
	emit_signal("finished", "idle")
