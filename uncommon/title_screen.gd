extends Control


var hashe = 0

func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	hashe += 0.1
	if $Control2/Button.is_hovered() or $Control2/Button/Button3.is_hovered():
		$Control2/Button.position.x = lerp($Control2/Button.position.x,$Node2D.position.x,0.5)
	else:
		
		$Control2/Button.position.x = lerp($Control2/Button.position.x,$Node2D3.position.x,0.5)
	if $Control2/Button2.is_hovered():
		$Control2/Button2.position.x = lerp($Control2/Button2.position.x,$Node2D.position.x,0.5)
	else:
		$Control2/Button2.position.x = lerp($Control2/Button2.position.x,$Node2D3.position.x,0.5)
	$Control.position = Vector2(sin(hashe),cos(hashe))
	$Control.rotation_degrees = sin(hashe) / 3
	$Control2.position = Vector2(sin(hashe),cos(hashe))
	$Camera2D.position = Vector2(sin(hashe),acos(hashe))

func _on_button_pressed() -> void:
	get_tree().queue_delete(self)
	add_sibling(preload("res://uncommon/Game.tscn").instantiate())


func _on_button_2_pressed() -> void:
	add_sibling(preload("res://common/Pause Screen.tscn").instantiate())


func _on_button_mouse_entered() -> void:
	$AudioStreamPlayer.play()


func _on_button_2_mouse_entered() -> void:
	$AudioStreamPlayer.play()


func _on_button_3_mouse_entered() -> void:
	$AudioStreamPlayer.play()
