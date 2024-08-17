extends CanvasLayer


func _ready() -> void:
	print("cda")

func _on_button_pressed() -> void:
	get_tree().queue_delete(self)
	add_sibling(preload("res://uncommon/Game.tscn").instantiate())
