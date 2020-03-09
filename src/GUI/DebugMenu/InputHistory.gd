extends RichTextLabel


func _on_DebugMenu_command_entered(command, text):
	append_bbcode(text + "\n")
