extends Node2D


onready var table = $TableBtn

var table_pushed = false

var start_pos = Vector2.ZERO

var object_text = "the table"

func _ready():
	table.connect("pressed", self, "_on_drawers_pressed")
	table.connect("mouse_entered", self, "_on_entered")
	table.connect("mouse_exited", self, "_on_exit")
	GlobalSignals.connect("sentence_checker", self, "_sentence_check")
	start_pos = position

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
		"Pull the table":
			table_pushed = true
			table_move()
		"Push the table":
			table_pushed = true
			table_move()
		"Look at the table":
			if table_pushed:
				GlobalSignals.emit_signal("speak", "Somebody pushed the table over!")
			else:
				GlobalSignals.emit_signal("speak", "It's just a table.")							
		_:
			GlobalSignals.emit_signal("speak", "I can't do that.")
			
#		GlobalSignals.emit_signal("sentence_clear")

func table_move():
	print ("move table")
	GlobalSignals.emit_signal("table_pushed")
	var l_tween = create_tween()
	l_tween.tween_property($TableBtn, "rect_rotation", -72.0, 0.7 )
#		l_tween.tween_property(self, "global_position",  start_pos, 0.2 )
#	light_tween.interpolate_property(self, "position", start_pos, Vector2(start_pos.x+20,start_pos.y), 0.4, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
#	light_tween.interpolate_property(self, "position", Vector2(start_pos.x+20, start_pos.y), Vector2(start_pos.x,start_pos.y), 0.4, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
#
#	light_tween.start()	
