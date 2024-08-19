extends Area2D


func _on_body_entered(body: Node2D) -> void:
	$AnimationPlayer.play("open")
	$AnimationPlayer.play()


func _on_body_exited(body: Node2D) -> void:
	$AnimationPlayer.play("close")
