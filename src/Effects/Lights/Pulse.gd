tool
extends Light2D

export(float) var MIN_ENERGY : float = 0.0
export(float) var MAX_ENERGY : float = 1.0
export(float, 0.05, 120, 0.05) var duration_sec : float = 1.0
export(bool) var active : bool = true

onready var energy_step : float = ((MAX_ENERGY - MIN_ENERGY) / duration_sec)
onready var time_sec : float  = 0.0


func _ready():
	if Engine.editor_hint:
		self.set_energy(MIN_ENERGY)
	if not Engine.editor_hint:
		self.set_energy(MIN_ENERGY)


func _process(delta : float):
	if Engine.editor_hint:
		self.set_energy(MIN_ENERGY)
	if not Engine.editor_hint:
		if active:
			time_sec += delta
			if time_sec <= duration_sec * 0.5:
				self.set_energy(self.get_energy() + (energy_step * delta))
			elif time_sec < duration_sec:
				self.set_energy(self.get_energy() - (energy_step * delta))
			else:
				time_sec = 0


