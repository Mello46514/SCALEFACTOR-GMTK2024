extends Node2D








func _process(delta: float) -> void:
	if $Area2D.has_overlapping_bodies() and Input.is_action_just_pressed("interact"):
		get_tree().change_scene_to_file("res://Credits.tscn")
