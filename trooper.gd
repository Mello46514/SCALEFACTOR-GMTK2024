extends Node2D

@export var lefright = false
@export var offset = 0

var alive = true

func _process(delta: float) -> void:
	$Sprite2D.flip_h = lefright
	$"SHOOT DIR".rotation_degrees = offset
	if $Area2D.has_overlapping_bodies():
		print("collide")
		alive = false
	if not alive:
		alive = true
		$Timer.stop()
		$Timer.one_shot = true
		$AudioStreamPlayer2D2.play()
		$Sprite2D.visible = false

func _on_timer_timeout() -> void:
	if alive:
		$AudioStreamPlayer2D.play()
		var e = preload("res://common/bullet.tscn").instantiate()
		e.rotation = $"SHOOT DIR".rotation
		get_child(4).add_child(e)


func _on_area_2d_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	alive = false
	print("collide")
