extends Node
class_name StateMachine

var state = null setget set_state
var previous_state = null
var states = {}

signal changed_state

onready var parent = get_parent()

func _physics_process(delta):
	if state != null:
		_state_logic(delta)
		var transition = _get_transition(delta)
		if transition != null:
			set_state(transition)

func _state_logic(delta: float) -> void:
	pass

func _get_transition(delta : float):
	return null

func _enter_state(new_state, old_state) -> void:
	pass

func _exit_state(old_state, new_state) -> void:
	pass

func set_state(new_state):
	previous_state = state
	state = new_state
	if previous_state != null:
		_exit_state(previous_state, state)
	if state != null:
		_enter_state(state, previous_state)
		
	emit_signal("changed_state", state, previous_state)

func add_state(state_name : String) -> void:
	states[state_name] = states.size()
