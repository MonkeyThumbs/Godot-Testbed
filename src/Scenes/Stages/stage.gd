tool
extends Scene
class_name Stage


signal daybreak
signal nightfall


export(float, 1, 4800, 1) var DAY_LENGTH_SEC : float = 360.0
export(float, 0, 1, 0.01) var START_TIME_PERCENT : float = 0
export(float, 0, 1, 0.01) var DAYBREAK_LEVEL : float = 0.5
export(float, 0, 1, 0.01) var MAX_AMBIENT_LIGHT : float = 1.0
export(float, 0, 1, 0.01) var MIN_AMBIENT_LIGHT : float = 0.0
export(Color) var MODULATION_COLOR : Color = Color.white
export(bool) var modulate_background : bool = true
export(bool) var modulate_foreground : bool = true
export(bool) var update_day_cycle : bool = true
export(bool) var update_in_editor : bool = false

var pause_timer = 0.0
var orig_zoom = 0.0
var orig_offset = Vector2()
var player = null
var is_daytime : bool = true

var ambient_light_level : float = 1 setget set_ambient_light_level, get_ambient_light_level

onready var camera := $Camera2D
onready var health_bar := $GUI/HealthBar
onready var game_over_screen := $GUI/GameOverScreen
onready var music := $Music
onready var music_tween := $MusicTween
onready var background := $ParallaxLayers
onready var ambient_light := $AmbientLight
onready var day_timer := $DaypartTimer
onready var entrances := $Entrances
onready var default_entrance := $Entrances/Default


func _ready():
	if Engine.editor_hint:
		_init_day_cycle()
		
	if not Engine.editor_hint:
		_init_day_cycle()
		_init_player()
		
		orig_zoom = camera.zoom
		orig_offset = camera.offset
		
#		if !music.playing:
#			music.play()


func _exit_tree():
	if not Engine.editor_hint:
		Globals.reparent_node(player, camera, self)
		self.remove_child(player)
		player.disconnect("health_changed", health_bar, "_on_health_changed")
		player.disconnect("max_health_changed", health_bar, "_on_max_health_changed")
		player.disconnect("health_depleted", game_over_screen, "_on_health_depleted")
		player.disconnect("health_depleted", self, "_on_health_depleted")
		player.disconnect("mana_changed", health_bar, "_on_mana_changed")
		player.disconnect("max_mana_changed", health_bar, "_on_max_mana_changed")
		player.disconnect("mana_depleted", health_bar, "_on_mana_depleted")


func _handle_input(event : InputEvent) -> void:
	if not Engine.editor_hint:
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
#
	#	if event.is_action_pressed("debug_music_toggle"):
	#		$Scene/Music_Background.stream_paused = !$Scene/Music_Background.stream_paused
	#
	#	if event.is_action_pressed("gui_open"):
	#		$Scene/ParallaxBackgrounds/Vinette/Vinette/GameSettings.visible = !$Scene/ParallaxBackgrounds/Vinette/Vinette/GameSettings.visible


func _process(delta):
	if Engine.editor_hint:
		_update_day_cycle(delta) if update_in_editor else _init_day_cycle()
	
	if not Engine.editor_hint:
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
		
		if Input.is_key_pressed(KEY_1):
			player.current_spell = Spells.FIREBOLT
		elif Input.is_key_pressed(KEY_2):
			player.current_spell = Spells.LIGHTNING
		elif Input.is_key_pressed(KEY_3):
			player.current_spell = Spells.HEAL
		
		if update_day_cycle:	_update_day_cycle(delta)


func _init_player() -> void:
	player = GameData.player_instance
	add_child(player)
	
	if GameData.stage_entrance < entrances.get_child_count():
		player.set_position(entrances.get_child(GameData.stage_entrance).get_position())
	else:
		player.set_global_position(default_entrance.get_position())
	
	player.connect("health_changed", health_bar, "_on_health_changed")
	player.connect("max_health_changed", health_bar, "_on_max_health_changed")
	player.connect("health_depleted", game_over_screen, "_on_health_depleted")
	player.connect("health_depleted", self, "_on_health_depleted")
	player.connect("mana_changed", health_bar, "_on_mana_changed")
	player.connect("max_mana_changed", health_bar, "_on_max_mana_changed")
	player.connect("mana_depleted", health_bar, "_on_mana_depleted")
	player.emit_signal("max_health_changed", player.get_max_health())
	player.emit_signal("health_changed",player.get_health(), 0)
	
	Globals.reparent_node(self, camera, player)
#	camera = player.get_node("Camera2D")


func _init_day_cycle() -> void:
	if Engine.editor_hint:
		if update_in_editor:
			$DaypartTimer.start(DAY_LENGTH_SEC - DAY_LENGTH_SEC * START_TIME_PERCENT)
		set_ambient_light_level( range_lerp(sin(((DAY_LENGTH_SEC - 
			DAY_LENGTH_SEC * START_TIME_PERCENT) / DAY_LENGTH_SEC) * PI), 0,1, 
			MIN_AMBIENT_LIGHT,MAX_AMBIENT_LIGHT))
	
	if not Engine.editor_hint:
		day_timer.start(DAY_LENGTH_SEC - DAY_LENGTH_SEC * START_TIME_PERCENT)
		set_ambient_light_level( range_lerp(sin((day_timer.time_left / 
			DAY_LENGTH_SEC) * PI), 0,1, MIN_AMBIENT_LIGHT,MAX_AMBIENT_LIGHT))
		if START_TIME_PERCENT >= DAYBREAK_LEVEL:    is_daytime = true
		else:                                       is_daytime = false
	
	set_scene_modulation(Color(MODULATION_COLOR.r * get_ambient_light_level(),
							MODULATION_COLOR.g * get_ambient_light_level(),
							MODULATION_COLOR.b * get_ambient_light_level(),
							MODULATION_COLOR.a))


func _update_day_cycle(delta : float):
	var amount : float = 0
	if Engine.editor_hint:
		amount = -(ambient_light_level - range_lerp(sin(($DaypartTimer.time_left / 
			DAY_LENGTH_SEC) * PI), 0,1, MIN_AMBIENT_LIGHT,MAX_AMBIENT_LIGHT)) * delta
	if not Engine.editor_hint:
		amount = -(ambient_light_level - range_lerp(sin((day_timer.time_left / 
			DAY_LENGTH_SEC) * PI), 0,1, MIN_AMBIENT_LIGHT,MAX_AMBIENT_LIGHT)) * delta
	set_ambient_light_level(ambient_light_level + amount)
	modulate_scene(amount)
	
	if not Engine.editor_hint:
		if get_ambient_light_level() >= DAYBREAK_LEVEL and not is_daytime:
			is_daytime = true
			emit_signal("daybreak")
		elif is_daytime: 
			is_daytime = false
			emit_signal("nightfall")


func modulate_scene(amount : float) -> void:
	if Engine.editor_hint:
		if amount > 0:
			$AmbientLight.color = $AmbientLight.color.lightened(amount)
		else:
			$AmbientLight.color = $AmbientLight.color.darkened(-amount)
		if modulate_background:
			for layer in $ParallaxLayers.get_children():
				modulate_parallax_layer(layer, amount)
			
	if not Engine.editor_hint:
		if amount > 0:
			ambient_light.color = ambient_light.color.lightened(amount)
		else:
			ambient_light.color = ambient_light.color.darkened(-amount)
		if modulate_background:
			for layer in background.get_children():
				modulate_parallax_layer(layer, amount)


#func set_scene_modulation(value : float) -> void:
#	if Engine.editor_hint:
#		$AmbientLight.color = Color(value,value,value)
#		if modulate_background:
#			for layer in $ParallaxLayers.get_children():
#				set_parallax_layer_modulation(layer, value)
#	if not Engine.editor_hint:
#		ambient_light.color = Color(value,value,value)
#		if modulate_background:
#			for layer in background.get_children():
#				set_parallax_layer_modulation(layer, value)


func set_scene_modulation(color : Color) -> void:
	if Engine.editor_hint:
		$AmbientLight.color = color
		if modulate_background:
			for layer in $ParallaxLayers.get_children():
				set_parallax_layer_modulation(layer, color)
	if not Engine.editor_hint:
		ambient_light.color = color
		if modulate_background:
			for layer in background.get_children():
				set_parallax_layer_modulation(layer, color)


func set_ambient_light_level(value : float) -> void:
	ambient_light_level = value
	if ambient_light_level <= MIN_AMBIENT_LIGHT:   ambient_light_level = MIN_AMBIENT_LIGHT
	elif ambient_light_level >= MAX_AMBIENT_LIGHT: ambient_light_level = MAX_AMBIENT_LIGHT


func get_ambient_light_level() -> float:
	return ambient_light_level

#func set_parallax_layer_modulation(layer, value : float):
#	if layer is ParallaxBackground:
#		for node in layer.get_children():
#			set_parallax_layer_modulation(node, value)
#	else:
#		layer.modulate = Color(value,value,value)


func set_parallax_layer_modulation(layer, color : Color):
	if layer is ParallaxBackground:
		for node in layer.get_children():
			set_parallax_layer_modulation(node, color)
	else:
		layer.modulate = color


func modulate_parallax_layer(layer, amount : float):
	if layer is ParallaxBackground:
		for node in layer.get_children():
			set_parallax_layer_modulation(node, Color(MODULATION_COLOR.r * ambient_light_level,
												MODULATION_COLOR.g * ambient_light_level,
												MODULATION_COLOR.b * ambient_light_level,
												MODULATION_COLOR.a))
	elif layer > 0:
		layer.modulate = layer.modulate.lightened(amount)
	else:
		layer.modulate = layer.modulate.darkened(-amount)


func _on_health_depleted():
	music_tween.interpolate_property(music, "volume_db", music.volume_db, -100, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	music_tween.start()


func _on_DebugMenu_command_entered(command, text):
	match command[0]:
		"kill":
			if command.size() >= 2:
				if command[1] == "player":
					player.set_dead(true)
				else:
					var target = get_node(command[1])
					if target != null:
						target.set_dead(true)
		"print_scene_tree":
			print(self.get_children())


func _on_MainMenu_open():
	get_tree().set_pause(true)


func _on_MainMenu_close():
	get_tree().set_pause(false)
