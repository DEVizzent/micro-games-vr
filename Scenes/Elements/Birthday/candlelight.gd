extends Area3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
var already_blow: bool = false

func _ready():
	_on_animation_player_animation_finished("idle")
	area_entered.connect(blow)

func blow(area: Area3D):
	if area.has_meta("blow"):
		already_blow = true
		animation_player.play("blow")
	elif area.has_meta("danger") and !already_blow:
		animation_player.play("danger")
		

func check_completed() -> void:
	remove_from_group("target")
	if get_tree().get_nodes_in_group("target").size() < 1 :
		EventBus.emit_signal(EventBus.GAME_COMPLETED_EVENT)

func _on_animation_player_animation_finished(_anim_name:StringName):
	animation_player.speed_scale = randf_range(0.5, 1.5) 
	animation_player.play("idle")
