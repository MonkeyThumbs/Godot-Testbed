tool
extends LightEffect


export(float) var MIN_ENERGY : float = 0
export(float) var MAX_ENERGY : float = 1

export(float) var MIN_SCALE : float = 0
export(float) var MAX_SCALE : float = 1

export(int) var octaves : int = 4
export(float) var period : float = 1
export(float) var persistence : float = 1
export(bool) var active : bool = true

var noise : OpenSimplexNoise = OpenSimplexNoise.new()
var time : float = 0.0


func _ready():
	noise.seed = randi()
	noise.octaves = octaves
	noise.period = period
	noise.persistence = persistence


func _process(delta):
	if active:
		time += delta
		
		var sample = noise.get_noise_1d(time)
		sample = range_lerp(sample, -1,1, MIN_ENERGY,MAX_ENERGY)
		set_energy(sample)
		
		sample = noise.get_noise_1d(-time)
		sample = range_lerp(sample, -1,1, MIN_SCALE,MAX_SCALE)
		set_texture_scale(abs(sample))
