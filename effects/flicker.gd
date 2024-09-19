extends OmniLight3D

var noise = FastNoiseLite.new()
var time = 0.0

func _process(delta: float):
	time += delta

	var value = noise.get_noise_1d(time)
	light_energy = 0.8 + 0.2 * abs(value)
