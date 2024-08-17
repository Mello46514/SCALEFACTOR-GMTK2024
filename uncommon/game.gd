extends Node2D

var offset:Vector2 = Vector2.ZERO

var rooms = [preload("res://Rooms/End.tscn"),preload("res://Rooms/rooma1.tscn"),preload("res://Rooms/rooma2.tscn")]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_floor()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ESC") and Global.paused == false:
		delete_floor()
		Global.paused = true
		add_child(preload("res://common/Pause Screen.tscn").instantiate())

func add_room(hash):
	var a = rooms[hash].instantiate()
	a.position = offset
	if not hash == 0:
		offset += a.get_child(2).position
	get_child(0).add_child(a)

func add_floor():
	for b in range(randi_range(15,25)):
		add_room(randi_range(1,2))
	add_room(0)
	


func delete_floor():
	for i in range(get_child(0).get_child_count()):
		get_tree().queue_delete(get_child(0).get_child(i))
