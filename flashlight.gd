extends Node3D

signal game_completed

const SUCCESS_COUNTER: int = 6

var timer: Timer
var raycast: RayCast3D
var findingSound: AudioStreamPlayer3D
var light: SpotLight3D
var counter:int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer = $Timer
	raycast = $RayCast3D
	findingSound = $Finding
	light = $SpotLight3D
	timer.timeout.connect(check_raycast)

func check_raycast() -> void:
	raycast.force_raycast_update()
	if (!raycast.is_colliding()):
		counter = 0
		findingSound.stop()
		return
	counter = counter + 1
	light.light_energy = float(counter)
	if (counter == 1) :
		findingSound.play(0.0)
	if counter >= SUCCESS_COUNTER :
		emit_signal("game_completed")
		_bigFlash()
		timer.stop()
		
func _bigFlash() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(light, "light_energy", 100.0, 1.0)
	tween.tween_property(light, "light_energy", 1.0, .01)
	findingSound.stop()
	
