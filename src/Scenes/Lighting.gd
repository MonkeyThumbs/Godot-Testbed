extends Node2D

func fade_self(color : Color) -> void:
	$Tween.interpolate_property(self, "modulate", 
		self.modulate, color, 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()


func fade_light(light : Light2D, energy : float) -> void:
	$Tween.interpolate_property(light, "energy", 
		light.energy, energy, 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()


func _on_daybreak() -> void:
	self.fade_self(Color(1,1,1,0))
	for light in self.get_children():
		if light is Light2D: 
			light.active = false
			self.fade_light(light, 0)


func _on_nightfall() -> void:
	self.fade_self(Color(1,1,1,1))
	for light in self.get_children():
		if light is Light2D: 
			light.active = true
			self.fade_light(light, 1)
