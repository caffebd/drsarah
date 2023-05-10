extends Control


onready var comic_image := $"%ComicImage"
onready var label := $"%Sentence"

var to_read := ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setup_panel(image: String, sentence: String, voice: String):
	$"%ComicImage".texture_normal = load(image)
	$"%Sentence".text = sentence
	to_read = voice




func _on_voice_pressed():
	GlobalSignals.emit_signal("read_comic_panel",to_read )
