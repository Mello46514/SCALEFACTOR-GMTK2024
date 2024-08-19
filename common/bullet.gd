extends CharacterBody2D

const speed:float = 100000
 
func _physics_process(delta: float) -> void:
	velocity.x = sin(rotation) * speed * delta
	velocity.y = cos(rotation) * speed * delta
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	get_tree().queue_delete(self)
