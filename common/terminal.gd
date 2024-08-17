extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("spawned")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Enter"):
		printtt("->" + $CanvasLayer/TextEdit.text)
		term($CanvasLayer/TextEdit.text)
		$CanvasLayer/TextEdit.text = ""

func term(a: String):
	if a == "--help\n":
		var file = FileAccess.open("res://--help.txt", FileAccess.READ)
		printtt(file.get_as_text())
		return;
	if a == "--resume\n":
		Global.paused = false
		get_tree().queue_delete(self)
		return;
	if a == "--quit\n":
		Global.paused = false
		get_tree().change_scene_to_file("res://uncommon/Title Screen.tscn")
		get_tree().queue_delete(self)
		get_tree().queue_delete(get_parent())
	if a == "--quit desktop\n":
		get_tree().quit()
		return;
	if a == "--options -help\n":
		var f2 = FileAccess.open("res://options -help.txt", FileAccess.READ)
		printtt(f2.get_as_text())



func printtt(printee: String):
	$CanvasLayer/RichTextLabel.text = $CanvasLayer/RichTextLabel.text + "\n" + printee + "\n"
