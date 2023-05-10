extends TextureButton

var is_inventory_item:= false

export var object_text := "the padlock"

var the_player: KinematicBody2D

var is_on_shelf := false

var is_active = true

var state := "null"

func _ready():
	connect("pressed", self, "_on_pressed")
	GlobalSignals.connect("sentence_checker", self, "_sentence_check")
#	connect("mouse_entered", self, "_on_entered")
#	connect("mouse_exited", self, "_on_exit")
	GlobalSignals.connect("item_placed_on_shelf", self, "_placed_on_shelf")
	GlobalSignals.connect("padlock_opened", self, "_remove_me")



func _on_pressed():
	if GlobalVars.last_clicked == object_text:
		GlobalSignals.emit_signal("object_button_pressed")
	else:
		GlobalVars.last_clicked = object_text
		if object_text in GlobalVars.current_sentence:
			return
		if is_inventory_item and "Use" in GlobalVars.current_sentence and GlobalVars.current_sentence.length():
			GlobalSignals.emit_signal("update_on_hover", object_text, " on")
	#			GlobalSignals.emit_signal("add_with_preposition","on")
			GlobalVars.using_preposition = true
		else:
			GlobalSignals.emit_signal("update_on_hover", object_text)

#
#func _on_entered():
#	if object_text in GlobalVars.current_sentence:
#		return
#	if is_inventory_item and "Use" in GlobalVars.current_sentence and GlobalVars.current_sentence.length() < 5:
#		GlobalSignals.emit_signal("update_on_hover", object_text)
#		GlobalSignals.emit_signal("add_with_preposition","on")
#		GlobalVars.using_preposition = true
#	else:
#		GlobalSignals.emit_signal("update_on_hover", object_text)
#
#func _on_exit():
#	if GlobalVars.last_added == " on":
#		return
#	GlobalSignals.emit_signal("remove_object")

func _sentence_check(sentence):
	sentence = sentence.to_lower().strip_edges(true, true)
	var get := "get "+object_text
	var look := "look at "+object_text
	var open:= "open " + object_text
	var use := "use "+object_text
	var use_on := "use "+object_text+" on"	
	var on_shelf := "use "+object_text+" on the shelf"
	if not object_text in sentence:
		return
	match sentence:
		get:
			GlobalSignals.emit_signal("speak", "I cannot get the padlock. It is locked.")
		use:
			GlobalSignals.emit_signal("speak", "Maybe I need a key?")

		use_on:
			return
		"use the old key on the padlock":
			GlobalSignals.emit_signal("padlock_opened")
		look:
			GlobalSignals.emit_signal("speak", "This padlock looks to strong to break. I need a key.")
		_:
			GlobalSignals.emit_signal("speak", "I can't do that with "+object_text)


func _get_closer():
	GlobalSignals.emit_signal("speak", "I need to get closer.")

func _check_can_remove():
	if GlobalVars.object_used_up and is_inventory_item:
		GlobalVars.object_used_up = false
		GlobalSignals.emit_signal("sentence_clear")	
		queue_free()

func _placed_on_shelf(the_item):
	if the_item == object_text:
		if !is_on_shelf:
			GlobalSignals.emit_signal("remove_from_game_objects", object_text)
			queue_free()

func _remove_me():
	GlobalSignals.emit_signal("remove_from_game_objects", object_text)
	queue_free()
