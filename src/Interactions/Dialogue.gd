tool
extends Interaction

export(PackedScene) var dialogue_control : PackedScene = null
export(String, FILE) var DIALOGUE_FILE : String = ""

var window : Node = null

func _enter() -> void:
	if dialogue_control.can_instance():
		window = dialogue_control.instance()
		owner.add_child(window)
		window.set_visible(true)
		window.connect("closed", self, "_on_window_closed")
	else:
		printerr("\"Dialogue Control\" contains no instanceable nodes")


func _exit() -> void:
	if window:
		owner.remove_child(window)
		window.queue_free()


func _on_window_closed():
	activate(false)


func _get_configuration_warning():
	if not dialogue_control:
		return "Dialogue Control not set!"
	if DIALOGUE_FILE == "":
		return "Dialogue File not set!"
	return ""
