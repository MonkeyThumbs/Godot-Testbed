tool
extends LightEffect

export(float) var START_ENERGY : float = 1.0
export(float, 0.05, 120, 0.05) var duration_sec : float = 1.0
export(bool) var script_active : bool = true

onready var energy_step : float = START_ENERGY / duration_sec

func _ready():
	if Engine.editor_hint:
		self.set_energy(START_ENERGY)
	if not Engine.editor_hint:
		self.set_energy(START_ENERGY)

func _process(delta):
	if Engine.editor_hint:
		if script_active:
			self.set_energy(self.get_energy() - (energy_step * delta))
	if not Engine.editor_hint:
		if script_active:
			self.set_energy(self.get_energy() - (energy_step * delta))
