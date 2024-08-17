extends RigidBody2D

var alive:bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $Kill.has_overlapping_areas() and alive:
		alive = false
		var a = preload("res://common/box_explode.tscn").instantiate()
		a.emitting = true
		$Sprite2D.visible = false
		$CollisionShape2D.disabled = true
		freeze = true
		add_child(a)
