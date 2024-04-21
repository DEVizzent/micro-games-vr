extends Area3D

const VU_COUNT = 16
const FREQ_MAX = 11050.0

const WIDTH = 800
const HEIGHT = 250
const HEIGHT_SCALE = 8.0
const MIN_DB = 60
const ANIMATION_SPEED = 0.1

signal blow()
signal stop_blowing()

@onready var dangerArea: Area3D = $Danger
var min_values: Array = []
var max_values: Array = []
var spectrum: AudioEffectInstance
var counter: int = 0
var is_blowing_active: bool = false

func _ready()->void:
	set_meta("blow", true)
	dangerArea.set_meta("danger", true)
	var idx = AudioServer.get_bus_index("Record")
	spectrum = AudioServer.get_bus_effect_instance(idx, 1)
	min_values.resize(VU_COUNT)
	max_values.resize(VU_COUNT)
	min_values.fill(0.0)
	max_values.fill(0.0)
	blow.connect(activate_blowing_area)
	stop_blowing.connect(deactivate_blowing_area)


func _process(_delta)->void:
	counter += 1
	if (counter % 7) == 0:
		blowing()
		counter = 0


func blowing()->void:
	var prev_hz = 0
	var height_limit = 0
	var is_blowing = true


	for i in range(1, VU_COUNT + 1):
		var hz = i * FREQ_MAX / VU_COUNT
		var magnitude = spectrum.get_magnitude_for_frequency_range(prev_hz, hz).length()
		var energy = clampf((MIN_DB + linear_to_db(magnitude)) / MIN_DB, 0, 1)
		var height = energy * HEIGHT * HEIGHT_SCALE
		if i == 1:
			height_limit = height
			if height_limit == 0:
				height_limit = -1
		else:
			if height > height_limit:
				is_blowing = false
		prev_hz = hz
	if is_blowing and not is_blowing_active:
		is_blowing_active = true
		emit_signal("blow")
		return
	if not is_blowing and is_blowing_active:
		is_blowing_active = false
		emit_signal("stop_blowing")

func activate_blowing_area()->void:
	set_collision_layer_value(15, true)
	dangerArea.set_collision_layer_value(15, true)

func deactivate_blowing_area()->void:
	set_collision_layer_value(15, false)
	dangerArea.set_collision_layer_value(15, false)
