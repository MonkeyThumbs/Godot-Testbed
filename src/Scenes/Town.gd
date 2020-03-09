extends Node2D


signal daybreak
signal nightfall

export(float, 1, 4800, 1) var DAY_LENGTH_SEC : float = 360.0
export(float, 0, 1, 0.01) var START_TIME_PERCENT : float = 0
export(float, 0, 1, 0.025) var DAYBREAK_LEVEL : float = 0.5
export(float, 0, 1, 0.1) var MAX_AMBIENT_LIGHT : float = 1.0
export(float, 0, 1, 0.1) var MIN_AMBIENT_LIGHT : float = 0.0

var pause_timer = 0.0
var orig_zoom = 0.0
var orig_offset = Vector2()

var ambient_light : float = 1 setget set_ambient_light, get_ambient_light

onready var camera = $PlayerV3/Camera2D
onready var main_menu = $GUI/MainMenu
onready var fps_display = $GUI/FPSDisplay
onready var player = $PlayerV3
onready var music = $Music
onready var sky = $Background/Sky
onready var city = $Background/City
onready var city_lights = $Background/City/Lights
onready var canvas = $Lighting/CanvasModulate
onready var day_timer = $DaypartTimer

#onready var ambient_light : float = range_lerp(daypart_length * daypart, 0,DAY_LENGTH_SEC, MIN_AMBIENT_LIGHT,MAX_AMBIENT_LIGHT)

func _ready():
	get_tree().set_pause(false)
	day_timer.start(DAY_LENGTH_SEC * (START_TIME_PERCENT / DAY_LENGTH_SEC))
	set_ambient_light(range_lerp(START_TIME_PERCENT / DAY_LENGTH_SEC, 0,1, MIN_AMBIENT_LIGHT,MAX_AMBIENT_LIGHT))
	set_scene_modulation(get_ambient_light())
	
	
	orig_zoom = camera.zoom
	orig_offset = camera.offset
	
	if Globals.entrance_position.length() > 0:
		player.set_global_position(Globals.entrance_position)
	
	if !music.playing:
		music.play()


func _unhandled_input(event):
#	if event.is_action_pressed("ui_cancel"):
#		main_menu.visible = !main_menu.visible
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
	
	if Input.is_key_pressed(KEY_BRACELEFT):
		modulate_scene(-0.2 * delta)
	elif Input.is_key_pressed(KEY_BRACERIGHT):
		modulate_scene(0.2 * delta)
	
	if Input.is_key_pressed(KEY_1):
		player.current_spell = Spells.FIREBOLT
	elif Input.is_key_pressed(KEY_2):
		player.current_spell = Spells.LIGHTNING
	elif Input.is_key_pressed(KEY_3):
		player.current_spell = Spells.HEAL
	
	if Input.is_key_pressed(KEY_PAUSE):
		if (pause_timer <= 0.0):
			get_tree().paused = !get_tree().paused
			pause_timer = 0.5
				
	if pause_timer > 0.0:
		pause_timer -= delta
	
	# Day/Night Cycle
	_update_day_cycle(delta)


func _update_day_cycle(delta : float):
	var amount = -(ambient_light - range_lerp(sin((day_timer.time_left / 
		DAY_LENGTH_SEC) * PI), 0,1, MIN_AMBIENT_LIGHT,MAX_AMBIENT_LIGHT)) * delta
	set_ambient_light(ambient_light + amount)
#	print(get_ambient_light())
	
	if get_ambient_light() >= DAYBREAK_LEVEL: emit_signal("daybreak")
	else: emit_signal("nightfall")


func modulate_scene(amount : float) -> void:
	if amount > 0:
		sky.modulate = sky.modulate.lightened(amount)
		city.modulate = city.modulate.lightened(amount)
		canvas.color = canvas.color.lightened(amount)
	else:
		sky.modulate = sky.modulate.darkened(-amount)
		city.modulate = city.modulate.darkened(-amount)
		canvas.color = canvas.color.darkened(-amount)


func set_scene_modulation(value : float) -> void:
		sky.modulate = Color(value,value,value)
		city.modulate = Color(value,value,value)
		canvas.color = Color(value,value,value)


func set_ambient_light(value : float) -> void:
	ambient_light = value
	if ambient_light <= MIN_AMBIENT_LIGHT:   ambient_light = MIN_AMBIENT_LIGHT
	elif ambient_light >= MAX_AMBIENT_LIGHT: ambient_light = MAX_AMBIENT_LIGHT


func get_ambient_light() -> float:
	return ambient_light


func _on_DaypartTimer_timeout():
	day_timer.start(DAY_LENGTH_SEC)


func _on_Town_daybreak():
	$Lighting/Tween.interpolate_property(city_lights, "modulate", 
		city_lights.modulate, Color(1,1,1,0), 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Lighting/Tween.start()


func _on_Town_nightfall():
	$Lighting/Tween.interpolate_property(city_lights, "modulate", 
		city_lights.modulate, Color(1,1,1,1), 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Lighting/Tween.start()
