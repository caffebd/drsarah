extends Node2D




var object_text = "the cup"

var item = "the cup"


func _ready():
	connect("pressed", self, "_on_pressed")
	GlobalSignals.connect("sentence_checker", self, "_sentence_check")
	connect("mouse_entered", self, "_on_entered")
	connect("mouse_exited", self, "_on_exit")


func _on_pressed():
	GlobalSignals.emit_signal("object_button_pressed")

func _on_entered():
	GlobalSignals.emit_signal("update_on_hover", object_text)

func _on_exit():
	GlobalSignals.emit_signal("remove_object")	

func _sentence_check(sentence):
	if not object_text in sentence:
		return
	match sentence:
		"Get the cup":
			visible = false
			GlobalSignals.emit_signal("add_to_inventory_bar", self)
#			MyFirebaseFunctions.update_inventory("coin")
			GlobalSignals.emit_signal("sentence_clear")
		"Look at the cup":
			GlobalSignals.emit_signal("speak", "A golden cup.")
		_:
			GlobalSignals.emit_signal("speak", "I can't do that.")

	
