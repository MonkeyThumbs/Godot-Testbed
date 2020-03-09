extends LineEdit

func _gui_input(event : InputEvent) -> void:
	accept_event()

func _on_LineEdit_text_entered(new_text):
	clear()
