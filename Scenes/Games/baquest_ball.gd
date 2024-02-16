extends XRToolsSceneBase

@export_file('*.tscn') var next_game : String = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_game_completed() -> void:
	$CompleteMessage.visible = true
	if !$SuccessAudioStream.is_playing() :
		$SuccessAudioStream.play()
	
	get_tree().create_timer(3.0).timeout.connect(_next_minigame)
	
func _next_minigame() -> void:
	var scene_base : XRToolsSceneBase = XRTools.find_xr_ancestor(self, "*", "XRToolsSceneBase")
	scene_base.load_scene(next_game)
