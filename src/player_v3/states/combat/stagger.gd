
extends "../state.gd"


var knockback_direction = Vector2()


func enter():
	owner.change_animation("stagger")


func _process(delta):
	pass


func _on_animation_finished(anim_name):
	emit_signal("finished", "idle")
