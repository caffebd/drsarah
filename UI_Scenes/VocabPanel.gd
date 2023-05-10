extends Control

const vocab_button = preload("res://UI_Scenes/VocabButton.tscn")
onready var grid = $"%VocabGrid"

onready var the_panel = $VocabPanel

var vocab_word_list = ["Look at", "Get", "Give", "Use", "Push", "Pull","Put on", "Take off"]

func _ready():
	for word in vocab_word_list:
		var btn = vocab_button.instance()
		btn.my_word = word
		grid.add_child(btn)
#	hide_me()
		
func hide_me():
	for btn in grid.get_children():
		btn.visible = false
		btn.disabled = true


