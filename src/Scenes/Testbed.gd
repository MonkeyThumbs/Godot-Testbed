extends Node2D

var pause_timer = 0.0
var orig_zoom = 0.0
var orig_offset = Vector2()
onready var camera = $Camera2D
onready var main_menu = $ParallaxBackground/ParallaxLayer3/MainMenu
onready var fps_display = $ParallaxBackground/ParallaxLayer3/FPSDisplay

func _ready():
	orig_zoom = camera.zoom
	orig_offset = camera.offset

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		main_menu.visible = !main_menu.visible
	if event.is_action_pressed("ui_debug_menu"):
		fps_display.visible = !fps_display.visible
	
	if event.is_action_pressed("debug_zstep_out"):
		if camera.zoom < Vector2(1.0,1.0):
			camera.zoom += Vector2(0.1,0.1)
		elif camera.zoom >= Vector2(1.0,1.0) && camera.zoom < Vector2(10.0,10.0):
			camera.zoom += Vector2(1,1)
	elif event.is_action_pressed("debug_zstep_in") && camera.zoom > Vector2(0.01,0.01):
		if camera.zoom <= Vector2(1.0,1.0) && camera.zoom > Vector2(0.1,0.1):
			camera.zoom -= Vector2(0.1,0.1)
		elif camera.zoom > Vector2(1.0,1.0):
			camera.zoom -= Vector2(1.0,1.0)
	
#	if event.is_action_pressed("debug_music_toggle"):
#		$Scene/Music_Background.stream_paused = !$Scene/Music_Background.stream_paused
#
#
	if event.is_action_pressed("fullscreen_toggle"):
		OS.set_window_fullscreen(!OS.is_window_fullscreen())
#
#	if event.is_action_pressed("gui_open"):
#		$Scene/ParallaxBackgrounds/Vinette/Vinette/GameSettings.visible = !$Scene/ParallaxBackgrounds/Vinette/Vinette/GameSettings.visible


func _process(delta):
	if Input.is_action_pressed("debug_zoom_out") && camera.zoom < Vector2(10.0,10.0):
		camera.zoom += Vector2(0.1,0.1) * delta
		camera.offset.y += -24 * delta
	elif Input.is_action_pressed("debug_zoom_in") && camera.zoom > Vector2(0.01,0.01):
		camera.zoom += Vector2(-0.1,-0.1) * delta
		camera.offset.y += 24 * delta
	elif Input.is_action_pressed("debug_zoom_reset"):
		camera.zoom = orig_zoom
		camera.offset = orig_offset
	
	if Input.is_action_pressed("debug_pan_left") && camera.zoom < Vector2(10.0,10.0):
		camera.offset.x -= Globals.UNIT_SIZE * 2 * delta
	elif Input.is_action_pressed("debug_pan_right") && camera.zoom < Vector2(10.0,10.0):
		camera.offset.x += Globals.UNIT_SIZE * 2 * delta
	elif Input.is_action_pressed("debug_pan_up") && camera.zoom < Vector2(10.0,10.0):
		camera.offset.y -= Globals.UNIT_SIZE * 2 * delta
	elif Input.is_action_pressed("debug_pan_down") && camera.zoom < Vector2(10.0,10.0):
		camera.offset.y += Globals.UNIT_SIZE * 2 * delta
	
	if Input.is_key_pressed(KEY_PAUSE):
		if (pause_timer <= 0.0):
			get_tree().paused = !get_tree().paused
			pause_timer = 0.5
				
	if pause_timer > 0.0:
		pause_timer -= delta
