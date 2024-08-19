extends Node2D

func _process(_delta: float) -> void:
	if $Area2D.has_overlapping_bodies() and Input.is_action_just_pressed("interact"):
		get_parent().get_parent().delete_floor()
