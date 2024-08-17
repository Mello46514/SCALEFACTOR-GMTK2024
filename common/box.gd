extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $Kill.has_overlapping_areas():
		var a = preload("res://common/box_explode.tscn").instantiate()
		a.global_position = global_position
		a.emitting = true
		add_sibling(a)
		get_tree().queue_delete(self)
