extends Spell



func _on_AnimationPlayer_animation_finished(anim_name):
	self.queue_free()
