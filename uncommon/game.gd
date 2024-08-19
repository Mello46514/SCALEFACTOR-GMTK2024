extends Node2D

var offset:Vector2 = Vector2.ZERO
var floor:int = 0

var rooms = [preload("res://Rooms/End.tscn"),
preload("res://Rooms/rooma1.tscn"),
preload("res://Rooms/rooma2.tscn"),
preload("res://Rooms/rooma3.tscn"),
preload("res://Rooms/rooma_4.tscn"),
preload("res://Rooms/rooma_5.tscn"),
preload("res://Rooms/rooma6.tscn"),
preload("res://Rooms/rooma_7.tscn")
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_floor()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$AudioStreamPlayer.stream_paused = Global.paused
	if floor == 3:
		get_tree().change_scene_to_file("res://uncommon/End Scene.tscn")
		queue_free()
	if Input.is_action_just_pressed("ESC") and Global.paused == false: 
		Global.paused = true
		add_child(preload("res://common/Pause Screen.tscn").instantiate())

func add_room(hashe):
	var a = rooms[hashe].instantiate()
	a.position = offset
	if not hashe == 0:
		offset += a.get_child(2).position
	get_child(0).add_child(a)

func add_floor():
	offset = Vector2.ZERO
	$Player.global_position = Vector2(127,0)
	floor += 1
	for b in range(randi_range(15,25)):
		add_room(randi_range(1,7))
	add_room(0)
	


func delete_floor():
	for i in range(get_child(0).get_child_count()):
		get_tree().queue_delete(get_child(0).get_child(i))
	offset = $"Level gen".position
	add_floor()
	$Player.global_position = Vector2(127,0)


func _on_audio_stream_player_finished() -> void:
	$AudioStreamPlayer.play()
