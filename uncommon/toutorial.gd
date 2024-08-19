extends Node2D

func _process(delta: float) -> void:
	if $Area2D2.has_overlapping_bodies() and Input.is_action_just_pressed("interact"):
		get_tree().change_scene_to_file("res://uncommon/Title Screen.tscn")
		queue_free()
	if Input.is_action_just_pressed("ESC") and Global.paused == false: 
		Global.paused = true
		add_child(preload("res://common/Pause Screen.tscn").instantiate())
