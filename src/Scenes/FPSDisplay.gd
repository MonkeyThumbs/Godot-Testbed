extends Control

onready var fps_label = $PanelContainer/VBoxContainer/fps_label
onready var player_velocity_label = $PanelContainer/VBoxContainer/player_velocity_label

func _ready():
	pass

func _process(delta):
	fps_label.set_text("FPS: " + str(Engine.get_frames_per_second()))
