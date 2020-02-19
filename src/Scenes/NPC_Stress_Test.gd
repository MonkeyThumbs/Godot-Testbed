extends "./Testbed.gd"

var SomeLady = preload ("res://src/Actors/0.1.0/SomeLady.res")
var BeardyMan = preload ("res://src/Actors/0.1.0/BeardyMan.res")

var count : int = 2

func _ready():
	$ParallaxBackground/ParallaxLayer3/FPSDisplay/Label.set_text("Count: " + String(count))

func _input(event):
	if event.is_action_pressed("spawn_npc"):
		var position = Vector2()
		var instance = null
		position.x = 192 + (960 * randf())
		position.y = 500 * randf()
		if randf() > 0.5:
			instance = SomeLady.instance()
		else:
			instance = BeardyMan.instance()
		instance.position = position
		add_child(instance)
		count += 1
		$ParallaxBackground/ParallaxLayer3/FPSDisplay/Label.set_text("Count: " + String(count))
	
