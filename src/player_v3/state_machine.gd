class_name StateMachine
tool
extends Node

signal state_changed(current_state)

"""
You must set a starting node from the inspector or on
the node that inherits from this state machine interface
If you don't the game will crash (on purpose, so you won't 
forget to initialize the state machine)
"""
export(NodePath) var START_STATE
var states_map = {}

var states_stack = []
var current_state : State = null
var previous_state : State = null
var _active = false setget set_active


func _ready():
	for child in get_children():
		child.connect("finished", self, "_change_state")
	initialize(START_STATE)


func initialize(start_state):
	set_active(true)
	states_stack.push_front(get_node(start_state))
	current_state = states_stack[0]
	current_state.enter()


func set_active(value):
	_active = value
	set_physics_process(value)
	set_process_input(value)
	if !_active:
		states_stack = []
		current_state = null


func _unhandled_input(event):
	if !_active:
		return
	current_state.handle_input(event)


func _physics_process(delta):
	if !_active:
		return
	current_state.update(delta)


func _on_animation_finished(anim_name):
	if !_active:
		return
	current_state._on_animation_finished(anim_name)


func _change_state(state_name):
	if !_active:
		return
	previous_state = current_state
	current_state.exit()
	
	if state_name == "previous":
		states_stack.pop_front()
	else:
		states_stack[0] = states_map[state_name]
	
	current_state = states_stack[0]
	emit_signal("state_changed", states_stack)
	
	if state_name != "previous":
		current_state.enter()
		
		
func _get_configuration_warning() -> String:
	if not get_child_count() == 1:
		return "A StateMachine should have at least one child state"
	return ""
