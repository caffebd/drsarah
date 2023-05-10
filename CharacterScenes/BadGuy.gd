extends TextureButton

var is_inventory_item:= false

var object_text := "the mysterious person"

var the_player: KinematicBody2D

var is_on_shelf := false

var is_active = true

var state := "null"

onready var speak_box = $"%SpeakBox"
onready var speak = $"%BadGuySpeak"


func _ready():
	connect("pressed", self, "_on_pressed")
	GlobalSignals.connect("sentence_checker", self, "_sentence_check")
#	connect("mouse_entered", self, "_on_entered")
#	connect("mouse_exited", self, "_on_exit")
	GlobalSignals.connect("item_placed_on_shelf", self, "_placed_on_shelf")
	GlobalSignals.connect("bad_guy_speak", self, "_bad_guy_speak")

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

func _bad_guy_speak(text):
	speak_box.visible = true
	speak.text = text

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
	var take := "take "+object_text
	var pick_up := "pick up "+object_text
	var look := "look at "+object_text
	var use := "use "+object_text
	var use_on := "use "+object_text+" on"
	var give := "give "+object_text	
	var on_shelf_1 := "use "+object_text+" on the first shelf"
	var on_shelf_2 := "use "+object_text+" on the second shelf"
	var on_shelf_3 := "use "+object_text+" on the third shelf"
	if not object_text in sentence or state == "off":
		return
	match sentence:
		get:
			GlobalSignals.emit_signal("speak", "I can't do that can I!")
		take:
			GlobalSignals.emit_signal("speak", "I can't do that can I!")
		pick_up:
			GlobalSignals.emit_signal("speak", "I can't do that can I!")

		look:
			GlobalSignals.emit_signal("speak", "This must be Rakush. I wonder what he wants with this village?")
		_:
			GlobalSignals.emit_signal("speak", "I must find a way to get Rakush to leave.")

func get_item(sentence):
	if !is_inventory_item:
#				if the_player == null:
#					the_player = get_parent().get_parent().return_player()
		if !GlobalVars.check_drone_inventory():
			return
		var dist = rect_position.distance_to(GlobalVars.current_player.position)
		if dist > 200:
			_get_closer()
			return
		GlobalSignals.emit_signal("save_sentence", sentence)
		GlobalSignals.emit_signal("add_to_inventory_bar", object_text)
		GlobalSignals.emit_signal("sentence_clear")
		print ("Bc on shelf is "+str(is_on_shelf))
		if is_on_shelf:
			print ("blue c on shelf")
			GlobalSignals.emit_signal("remove_from_shelf", object_text)
		GlobalSignals.emit_signal("remove_from_game_objects", object_text)
		queue_free()
	else:
		GlobalSignals.emit_signal("speak", "You already have it.")
func _get_closer():
	print ("GET CLOSER")
	GlobalSignals.emit_signal("speak", "I need to get closer.")
	
func _get_closer_to_player():
	GlobalSignals.emit_signal("speak", "The drone needs to be closer to me.")


func _check_can_remove():
	if GlobalVars.object_used_up and is_inventory_item:
		GlobalVars.object_used_up = false
		GlobalSignals.emit_signal("sentence_clear")	
		queue_free()

func _placed_on_shelf(the_item):
	if the_item == object_text:
		if !is_on_shelf:
			GlobalSignals.emit_signal("remove_from_inventory_list", object_text)
			queue_free()
		
func set_state(new_state):
	state = new_state
	
