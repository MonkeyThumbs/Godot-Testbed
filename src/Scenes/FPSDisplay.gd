extends Control

onready var fps_label = $PanelContainer/VBoxContainer/fps_label
onready var player_velocity_label = $PanelContainer/VBoxContainer/player_velocity_label

func _ready():
	pass


func _unhandled_input(event : InputEvent) -> void:
	if event.is_action_pressed("ui_debug_menu"):
		set_visible(!is_visible())

func _process(delta):
	fps_label.set_text("FPS: " + str(Engine.get_frames_per_second()))
