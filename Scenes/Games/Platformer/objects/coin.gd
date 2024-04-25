extends Area3D

var time := 0.0
var grabbed := false

# Collecting coins

func _on_body_entered(body):
	if body.is_in_group("player") and !grabbed:
		remove_from_group("target")
		
		$CoinAudio.play() # Play sound
		$Mesh.queue_free() # Make invisible
		$Particles.emitting = false # Stop emitting stars
		grabbed = true
		
		if get_tree().get_nodes_in_group("target").size() < 1 :
			EventBus.emit_signal(EventBus.GAME_COMPLETED_EVENT)

# Rotating, animating up and down

func _process(delta):
	
	rotate_y(2 * delta) # Rotation
	position.y += (cos(time * 5) * 1) * delta # Sine movement
	
	time += delta
