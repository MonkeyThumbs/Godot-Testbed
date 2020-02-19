extends Node

enum {LOAD_SUCCESS, LOAD_ERROR_COULDNT_OPEN}

const SAVE_PATH = "res://config.cfg"

var _config_file = ConfigFile.new()

var _settings = {
	"audio": {
		"mute": Globals.get("Settings/mute")
	},
	"debug": {
		"vector_color": Color(1.0, 0.0, 1.0),
		"area_color": Color(0.0, 1.0, 0.4, 0.5)
	}
}

func _ready():
	save_settings()
	load_settings()

func save_settings():
	for section in _settings.keys():
		for key in _settings[section].keys():
			_config_file.set_value(section, key, _settings[section][key])

	_config_file.save(SAVE_PATH)



func load_settings():
	var error = _config_file.load(SAVE_PATH)
	if error != OK:
		print("Error loading the settings. Error code: %s" % error)
		return LOAD_ERROR_COULDNT_OPEN

	for section in _settings.keys():
		for key in _settings[section].keys():
			var val = _config_file.get_value(section,key)
			_settings[section][key] = val
			print("%s: %s" % [key, val])
	return LOAD_SUCCESS


func get_setting(category, key):
	return _settings[category][key]


func set_setting(category, key, value):
	_settings[category][key] = value
