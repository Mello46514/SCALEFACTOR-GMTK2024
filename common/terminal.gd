extends Control

@export var kill:bool = false

var save_dicta = {
	"sound" : 100,
	"music" : 100,
	"fullscreen" : 0
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	save_game()
	load_game()
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(_delta: float) -> void:
	if kill:
		Global.paused = false
		get_tree().queue_delete(self)
		return;
	if Input.is_action_just_pressed("Enter"):
		printtt("->" + $CanvasLayer/Node2D/TextEdit.text)
		term($CanvasLayer/Node2D/TextEdit.text)
		$CanvasLayer/Node2D/TextEdit.text = ""

func term(a: String):
	if a == "--help\n":
		var file = FileAccess.open("res://--help.txt", FileAccess.READ)
		printtt(file.get_as_text())
		return;
	if a == "--resume\n":
		$AnimationPlayer.play("leave")
	if a == "--options -help\n":
		var f2 = FileAccess.open("res://options -help.txt", FileAccess.READ)
		printtt(f2.get_as_text())
	if a == "--fullscreen 1\n" or a == "--fullscreen 0\n":
		save_dicta = {"fullscreen" : int(a)}
		if int(a) == 1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		if int(a) == 0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

	if a == "--quit\n":
		Global.paused = false
		get_tree().change_scene_to_file("res://uncommon/Title Screen.tscn")
		get_tree().queue_delete(self)
		get_tree().queue_delete(get_parent())
	if a == "--quit desktop\n":
		get_tree().quit()
		return;
	save_game()

func printtt(printee: String):
	$CanvasLayer/Node2D/RichTextLabel.text = $CanvasLayer/Node2D/RichTextLabel.text + "\n" + printee + "\n"

func save():
	return save_dicta

func save_game():
	var save_game = FileAccess.open("user://Save.save", FileAccess.WRITE)
	
	var json_string = JSON.stringify(save())
	
	save_game.store_line(json_string)

func load_game():
	if not FileAccess.file_exists("user://Save.save"):
		print("ERROR")
		return
	
	var save_game = FileAccess.open("user://Save.save", FileAccess.READ)
	
	while save_game.get_position() < save_game.get_length():
		var json_string = save_game.get_line()
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		var data = json.get_data()
		print(data)
		Global.Fullscreen = data["fullscreen"]
		Global.sound = data["sound"]
		Global.music = data["music"]
