extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(_on_body_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_body_entered(body: Node3D) -> void:
	if body.get_name() == "PlayerBody":
		EventBus.emit_signal(EventBus.GAME_COMPLETED_EVENT)
		

