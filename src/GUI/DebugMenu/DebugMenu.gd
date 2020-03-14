extends Control

signal command_entered(command, text)

func _unhandled_input(event : InputEvent):
	if event.is_action_pressed("ui_debug_menu"):
		self.set_visible(!self.is_visible())
		if self.is_visible():
			$HBoxContainer/VBoxContainer/LineEdit.grab_focus()

func _on_LineEdit_text_entered(new_text : String):
	var commands = []
	var index : int = 0
	while index != -1:
		var prev_index := index
		index = new_text.find(" ", index + 1)
		if index == -1:
			if prev_index == 0:
				commands.append(new_text)
			else:
				commands.append(new_text.right(prev_index + 1))
		else:
			commands.append(new_text.left(index))
	
	var output_text : String
	
	for command in commands:
		match command:
			"kill":
				output_text += "[color=aqua]"
				output_text += command
				output_text += "[/color] "
			"print_scene_tree":
				output_text += "[color=green]"
				output_text += command
				output_text += "[/color] "
			_:
				output_text += command
				output_text += " "
	
	emit_signal("command_entered", commands, output_text)
