extends Node2D


onready var portrait = $PortraitBtn

var portrait_pushed = false

var start_pos = Vector2.ZERO

var object_text = "the portrait"

func _ready():
	portrait.connect("pressed", self, "_on_drawers_pressed")
	portrait.connect("mouse_entered", self, "_on_entered")
	portrait.connect("mouse_exited", self, "_on_exit")
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
		"Pull the portrait":
			portrait_pushed = true
			portrait_move("pull")
		"Push the portrait":
			portrait_pushed = false
			portrait_move("push")
		"Look at the portrait":
			if portrait_pushed:
				GlobalSignals.emit_signal("speak", "Somebody has moved the portrait.")
			else:
				GlobalSignals.emit_signal("speak", "It's a painting of a boy.")							
		_:
			GlobalSignals.emit_signal("speak", "I can't do that.")
			
#		GlobalSignals.emit_signal("sentence_clear")

func portrait_move(dir: String):
	print ("move port")
	var l_tween = create_tween()
	if dir == "pull":
		l_tween.tween_property(portrait, "rect_rotation", 12.0, 1 )
	else:
		l_tween.tween_property(portrait, "rect_rotation", 0.0, 1 )
#		l_tween.tween_property(self, "global_position",  start_pos, 0.2 )
#	light_tween.interpolate_property(self, "position", start_pos, Vector2(start_pos.x+20,start_pos.y), 0.4, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
#	light_tween.interpolate_property(self, "position", Vector2(start_pos.x+20, start_pos.y), Vector2(start_pos.x,start_pos.y), 0.4, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
#
#	light_tween.start()	
