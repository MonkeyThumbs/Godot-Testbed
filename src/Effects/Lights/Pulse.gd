tool
extends LightEffect

export(float) var MIN_ENERGY : float = 0.0
export(float) var MAX_ENERGY : float = 1.0
export(float) var MIN_SCALE : float = 0.0
export(float) var MAX_SCALE : float = 1.0
export(float, 0.05, 120, 0.05) var duration_sec : float = 1.0
export(bool) var active : bool = true

var energy_step : float
var scale_step : float
var time_sec : float

func _ready():
	self.set_energy(MIN_ENERGY)
	self.set_texture_scale(MIN_SCALE)
	energy_step = ((MAX_ENERGY - MIN_ENERGY) / duration_sec) * 2
	scale_step = ((MAX_SCALE - MIN_SCALE) / duration_sec) * 2
	time_sec = 0.0


func _process(delta : float):
	if active:
		time_sec += delta
		if time_sec <= duration_sec * 0.5:
			self.call_deferred("set_energy", energy + (energy_step * delta))
			self.set_texture_scale(self.get_texture_scale() + (scale_step * delta))
		elif time_sec < duration_sec:
			self.call_deferred("set_energy", energy - (energy_step * delta))
			self.set_texture_scale(self.get_texture_scale() - (scale_step * delta))
		else:
			time_sec = 0
