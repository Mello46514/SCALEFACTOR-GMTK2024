extends Node2D


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "leave":
		get_tree().quit()
