extends TextureButton


var is_inventory_item:= false

export var object_text = "the fire"

var the_player: KinematicBody2D

var is_on_shelf := false

var is_active = true

var state := "null"

onready var fire_body = $StaticBody2D/FireBody

func _ready():
	connect("pressed", self, "_on_pressed")
	GlobalSignals.connect("sentence_checker", self, "_sentence_check")
	GlobalSignals.connect("wear_coat", self, '_coat_state')
#	connect("mouse_entered", self, "_on_entered")
#	connect("mouse_exited", self, "_on_exit")

func _coat_state(state):
	fire_body.disabled = state

func _on_pressed():
	GlobalVars.last_clicked = object_text
	GlobalVars.clicked_fire = self
	if object_text in GlobalVars.current_sentence:
		GlobalSignals.emit_signal("object_button_pressed")
		return
	if is_inventory_item and "Use" in GlobalVars.current_sentence and GlobalVars.current_sentence.length():
		GlobalSignals.emit_signal("update_on_hover", object_text, " on")
#			GlobalSignals.emit_signal("add_with_preposition","on")
		GlobalVars.using_preposition = true
	else:
		GlobalSignals.emit_signal("update_on_hover", object_text)
		GlobalSignals.emit_signal("object_button_pressed")


#func _on_entered():
#	GlobalSignals.emit_signal("update_on_hover", object_text)
#
#func _on_exit():
#	GlobalSignals.emit_signal("remove_object")	

func _sentence_check(sentence):
	sentence = sentence.to_lower().strip_edges(true, true)
	var water_used = "use the glass of water on "+object_text
	if not object_text in sentence:
		return
	print ("fire check")
	match sentence:
#		"use the glass of water on the fire":
#			var dist = rect_position.distance_to(GlobalVars.current_player.position)
#			if dist > 200:
#				_get_closer()
#				return
#			GlobalVars.object_used_up = true
##			get_parent().room_items["the fire"].active = false
#			GlobalSignals.emit_signal("remove_from_game_objects", object_text)	
#			queue_free()	
		water_used:
			return	
		"get the fire":
			GlobalSignals.emit_signal("speak", "I cannot pick up fire!")
		"look at the fire":
			GlobalSignals.emit_signal("speak", "It is too hot to walk past.")
		_:
			if not "glass" in sentence:
				GlobalSignals.emit_signal("speak", "I can't do that with fire!")

func _get_closer():
	GlobalSignals.emit_signal("speak", "I need to get closer.")

func remove_fire():
	$"%Extinguish".play()
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 3 )


func _on_Extinguish_finished():
	GlobalSignals.emit_signal("remove_from_game_objects", object_text)
	queue_free()
