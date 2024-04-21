extends Node3D

const SUCCESS_COUNTER: int = 6

@onready var timer: Timer = $Timer
@onready var raycast: RayCast3D = $RayCast3D
@onready var findingSound: AudioStreamPlayer3D = $Finding
@onready var light: SpotLight3D = $SpotLight3D
var xr_interface : XRInterface
var counter:int = 0
func _ready() -> void:
	xr_interface = XRServer.find_interface("OpenXR")
	if !(xr_interface is XRInterface) or !xr_interface.is_initialized():
		push_error("OpenXR not initialised, please check if your headset is connected")
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
		EventBus.emit_signal(EventBus.GAME_COMPLETED_EVENT)
		_bigFlash()
		timer.stop()
		
func _bigFlash() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(light, "light_energy", 100.0, 1.0)
	tween.tween_property(light, "light_energy", 1.0, .01)
	var tween_haptic = get_tree().create_tween()
	findingSound.stop()
	xr_interface.trigger_haptic_pulse("haptic", "right_hand", 300, 1, 0.2, 0.9)
	
