"""
Base interface for all states: it doesn't do anything in itself
but forces us to pass the right arguments to the methods below
and makes sure every State object had all of these methods.
"""
class_name State
extends Node

# warning-ignore:unused_signal
signal finished(next_state_name)

func enter():
	return

func exit():
	return

# warning-ignore:unused_argument
func handle_input(event):
	return

# warning-ignore:unused_argument
func update(delta):
	return

# warning-ignore:unused_argument
func _on_animation_finished(anim_name):
	return

func get_state_machine():
	return owner.get_node("StateMachine")
