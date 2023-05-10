extends Node2D


onready var plant = $PlantBtn

var plant_pushed = false

var start_pos = Vector2.ZERO

var object_text = "the small plant"

func _ready():
	plant.connect("pressed", self, "_on_drawers_pressed")
	plant.connect("mouse_entered", self, "_on_entered")
	plant.connect("mouse_exited", self, "_on_exit")
	GlobalSignals.connect("table_pushed", self, "_table_pushed")
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
		"Pull the small plant":
			GlobalSignals.emit_signal("speak", "I don't want to hurt it.")
		"Push the small plant":
			GlobalSignals.emit_signal("speak", "I don't want to hurt it.")
		"Look at the small plant":
			if plant_pushed:
				GlobalSignals.emit_signal("speak", "It's a lovely, small plant.")
			else:
				GlobalSignals.emit_signal("speak", "Somebody knocked it over.")							
		_:
			GlobalSignals.emit_signal("speak", "I can't do that.")
			
#		GlobalSignals.emit_signal("sentence_clear")


func _table_pushed():
	var l_tween = create_tween()
	l_tween.tween_property(self, "rotation", -7.0, 0.7 )
	l_tween.parallel().tween_property(self, "global_position", Vector2(868, 733), 1.0)
#		l_tween.tween_property(self, "global_position",  start_pos, 0.2 )
#	light_tween.interpolate_property(self, "position", start_pos, Vector2(start_pos.x+20,start_pos.y), 0.4, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
#	light_tween.interpolate_property(self, "position", Vector2(start_pos.x+20, start_pos.y), Vector2(start_pos.x,start_pos.y), 0.4, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
#
#	light_tween.start()	
