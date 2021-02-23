extends Particles2D



func _on_Wall_Slide_entered():
	emitting = true


func _on_Wall_Slide_finished(next_state_name):
	emitting = false
