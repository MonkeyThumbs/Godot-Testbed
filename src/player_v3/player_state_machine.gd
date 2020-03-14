extends "./state_machine.gd"

func _ready():
	states_map = {
		"idle": $Idle,
		"move": $Move,
		"crouch": $Crouch,
		"jump": $Jump,
		"tumble": $Tumble,
		"wall_slide": $Wall_Slide,
		"ledge_hang": $Ledge_Hang,
		"stagger": $Stagger,
		"attack": $Attack,
		"cast": $Cast,
		"cast_loop": $Cast_Loop,
		"die": $Die,
		"fall": $Fall,
	}

func _change_state(state_name):
	if !_active:
		return
	if state_name == "fall":
		if previous_state == null:
			pass
		elif current_state == $Jump:
			$Fall.initialiaze($Jump.AIR_STEERING_POWER)
		elif current_state == $Tumble:
			$Fall.initialiaze($Tumble.AIR_STEERING_POWER)
	._change_state(state_name)

func _unhandled_input(event):
	"""
	Here we only handle input that can interrupt states, otherwise we let the 
	state node handle it
	"""
	if current_state:
		current_state.handle_input(event)


func _on_AnimationPlayer_animation_finished(anim_name):
	._on_animation_finished(anim_name)


func _on_Health_health_depleted():
	_change_state("die")
