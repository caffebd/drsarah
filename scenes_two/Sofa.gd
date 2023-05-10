extends Node2D

var sofa_pulled: bool = false

onready var sofa = $SofaBtn
onready var sofa_tween = $SofaTween

var start_pos = Vector2.ZERO

var object_text = "the sofa"

func _ready():
	sofa.connect("pressed", self, "_on_drawers_pressed")
	sofa.connect("mouse_entered", self, "_on_entered")
	sofa.connect("mouse_exited", self, "_on_exit")
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
		"Pull the sofa":
			if sofa_pulled:
				GlobalSignals.emit_signal("speak", "I cannot pull it again.")
			else:
				sofa_pulled = true
				sofa_move("pull")
		"Push the sofa":
			if !sofa_pulled:
				GlobalSignals.emit_signal("speak", "The wall is in the way.")
			else:
				sofa_pulled = false
				sofa_move("push")
		"Look at the sofa":
			GlobalSignals.emit_signal("speak", "An old sofa. Maybe something in under it.")
		_:
			GlobalSignals.emit_signal("speak", "I can't do that.")
			
#		GlobalSignals.emit_signal("sentence_clear")

func sofa_move(dir: String):
	if dir == "pull":
		sofa_tween.interpolate_property(self, "position", start_pos, Vector2(start_pos.x+80,start_pos.y), 0.7, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	else:
		sofa_tween.interpolate_property(self, "position", Vector2(start_pos.x+80, start_pos.y), Vector2(start_pos.x,start_pos.y), 0.7, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	sofa_tween.start()	
