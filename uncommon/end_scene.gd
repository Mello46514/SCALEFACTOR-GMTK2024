extends Node2D




func _physics_process(delta: float) -> void:
	$AudioStreamPlayer.stream_paused = Global.paused
	$AudioStreamPlayer2.stream_paused = Global.paused
	$Timer.paused = Global.paused
	$CanvasLayer/Label.text = str($Timer.time_left) + " seconds left..."
	if Input.is_action_just_pressed("ESC") and Global.paused == false: 
		Global.paused = true
		add_child(preload("res://common/Pause Screen.tscn").instantiate())


func _on_area_2d_body_entered(body: Node2D) -> void:
	$AudioStreamPlayer.play()


func _on_audio_stream_player_finished() -> void:
	$Timer.start(50)
	$AudioStreamPlayer2.play()
	$CanvasLayer/Label.visible = true


func _on_audio_stream_player_2_finished() -> void:
	$AudioStreamPlayer2.play()


func _on_timer_timeout() -> void:
	$Player.kill = true
