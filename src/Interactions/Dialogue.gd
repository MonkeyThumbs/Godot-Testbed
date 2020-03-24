tool
extends Interaction

export(PackedScene) var dialogue_control : PackedScene = null
export(String, FILE) var DIALOGUE_FILE : String = ""
export(String) var DIALOGUE_NAME : String = ""

var window : Node = null
var dialogue_pages = []

func _ready():
	_parse_dialogue()

func _enter() -> void:
	if dialogue_control.can_instance():
		window = dialogue_control.instance()
		owner.add_child(window)
		window.set_visible(true)
		for page in dialogue_pages:
			window.add_page(page)
		window.update_text()
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
	if DIALOGUE_NAME == "":
		return "Dialogue Name not set!"
	return ""


func _parse_dialogue():
	var file := File.new()
	if file.open(DIALOGUE_FILE, file.READ) != OK:
		return
	var text_json := file.get_as_text()
	var result_json = JSON.parse(text_json)
	var result = {}
	
	if result_json.error == OK:  # If parse OK
		result = result_json.result
		if typeof(result) == TYPE_ARRAY:
			var data = result[DIALOGUE_NAME]
			for page in data:
				dialogue_pages.push_back(page)
		elif typeof(result) == TYPE_DICTIONARY:
			var data = result.get(DIALOGUE_NAME)
			for page in data:
				dialogue_pages.push_back(page)
			
		
	else:  # If parse has errors
		print("Error: ", result_json.error)
		print("Error Line: ", result_json.error_line)
		print("Error String: ", result_json.error_string)
	return 
