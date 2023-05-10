extends TextureButton


var is_inventory_item:= false

var object_text = "the large fire"

var the_player: KinematicBody2D

var is_on_shelf := false

var is_active = true

var state := "null"

onready var fire_body = $"%FireCol"

var first_run := true

func _ready():
	connect("pressed", self, "_on_pressed")
	GlobalSignals.connect("sentence_checker", self, "_sentence_check")
	GlobalSignals.connect("bad_guy_fire", self, "_bad_guy_fire")
#	connect("mouse_entered", self, "_on_entered")
#	connect("mouse_exited", self, "_on_exit"
	set_state("off")

func _bad_guy_fire():
	set_state("on")
	
func set_state(new_state):
	state = new_state
	if state == "off":
		call_deferred("set_body", true)
		visible = false
	else:
		call_deferred("set_body", false)
		visible = true
		

func set_body(body_state):
	$"%FireCol".disabled = body_state
	$"%fire_detect".disabled = body_state



func _on_pressed():
	print ("top pressed")
	if GlobalVars.last_clicked == object_text and object_text in GlobalVars.current_sentence:
		GlobalSignals.emit_signal("object_button_pressed")
	else:
		GlobalVars.last_clicked = object_text
		if !GlobalVars.text_typing:
			if object_text in GlobalVars.current_sentence:
				return
		print (GlobalVars.current_sentence)
		if is_inventory_item and "Use" in GlobalVars.current_sentence:
			GlobalSignals.emit_signal("update_on_hover", object_text, " on")
#			GlobalSignals.emit_signal("add_with_preposition","on")
			GlobalVars.using_preposition = true
		elif is_inventory_item and "Give" in GlobalVars.current_sentence:
			GlobalSignals.emit_signal("update_on_hover", object_text, " to")
		else:
			GlobalSignals.emit_signal("update_on_hover", object_text)		

#func _on_entered():
#	GlobalSignals.emit_signal("update_on_hover", object_text)
#
#func _on_exit():
#	GlobalSignals.emit_signal("remove_object")	

func _sentence_check(sentence):
	sentence = sentence.to_lower().strip_edges(true, true)
	if not object_text in sentence:
		return
	print ("fire check")
	match sentence:
		"use the glass of water on the large fire":
			var dist = rect_position.distance_to(GlobalVars.current_player.position)
			if dist > 200:
				_get_closer()
				return
			GlobalVars.object_used_up = true
#			get_parent().room_items["the fire"].active = false
			GlobalSignals.emit_signal("remove_from_game_objects", object_text)	
			queue_free()		
		"get the large fire":
			GlobalSignals.emit_signal("speak", "You cannot pick up fire!")
		"look at the large fire":
			GlobalSignals.emit_signal("speak", "It is too hot to walk past.")
		_:
			if not "coat" in sentence:
				GlobalSignals.emit_signal("speak", "I can't do that with fire!")

func _get_closer():
	GlobalSignals.emit_signal("speak", "I need to get closer.")

func _check_can_remove():
	GlobalSignals.emit_signal("remove_from_game_objects", object_text)
	GlobalSignals.emit_signal("sentence_clear")	
	queue_free()


func _on_TooHot_body_entered(body):
	if body.name == "PlayerGirl":
		GlobalSignals.emit_signal("speak", "This fire is too hot even for my fireproof coat. I need to put it out or the village will burn down.")
