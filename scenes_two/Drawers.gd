extends Node2D

var drawer_open: bool = false

onready var drawer_opened = $drawers_open
onready var drawer_closed = $drawers_closed

var object_text = "the drawer"

func _ready():
	drawer_opened.connect("pressed", self, "_on_drawers_pressed")
	drawer_closed.connect("pressed", self, "_on_drawers_pressed")
	drawer_opened.connect("mouse_entered", self, "_on_entered")
	drawer_closed.connect("mouse_entered", self, "_on_entered")
	drawer_opened.connect("mouse_exited", self, "_on_exit")
	drawer_closed.connect("mouse_exited", self, "_on_exit")		
	GlobalSignals.connect("sentence_checker", self, "_sentence_check")

func _on_drawers_pressed():
	GlobalSignals.emit_signal("object_button_pressed")

func _on_entered():
	GlobalSignals.emit_signal("update_on_hover", object_text)

func _on_exit():
	GlobalSignals.emit_signal("remove_object")

func _sentence_check(sentence):
	if not object_text in sentence:
		return
	match sentence:
		"Close the drawer":
			if drawer_open == true:
				drawer_open = false
				drawer_closed.visible = true
				drawer_closed.disabled = false
				drawer_opened.visible = false
				drawer_opened.disabled = true
				GlobalSignals.emit_signal("sentence_clear")
			else:
				GlobalSignals.emit_signal("speak", "The drawer is already closed.")
		"Open the drawer":
			if drawer_open == false:
				drawer_open = true
				drawer_opened.visible = true
				drawer_opened.disabled = false
				drawer_closed.visible = false
				drawer_closed.disabled = true
				GlobalSignals.emit_signal("sentence_clear")
#				GlobalSignals.emit_signal("paper_fall")
			else:
				GlobalSignals.emit_signal("speak", "The drawer is already open.")
		"Look at the drawer":
			GlobalSignals.emit_signal("speak", "Only one of these drawers is not locked.")
		_:
			GlobalSignals.emit_signal("speak", "I can't do that.")
			
		

