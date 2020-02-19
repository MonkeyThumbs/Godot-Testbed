extends "./state_machine.gd"

func _ready():
	states_map = {
		"idle": $Idle,
		"move": $Move,
		"jump": $Jump,
		"stagger": $Stagger,
		"attack": $Attack,
		"fall": $Fall,
		"tumble": $Tumble,
	}

func _change_state(state_name):
	if not _active:
		return
	._change_state(state_name)

func _input(event):
	"""
	Here we only handle input that can interrupt states, otherwise we let the 
	state node handle it
	"""
#	if event.is_action_pressed("attack"):
#		if current_state == $Attack:
#			return
#		_change_state("attack")
#		return
	current_state.handle_input(event)
