extends TextureButton

var is_inventory_item:= false

var object_text := "the boy"

var the_player: KinematicBody2D

var is_on_shelf := false

var is_active = true

var state := "null"

var tut_click_count := 0

onready var clicks := $"%Clicks"
onready var click_label := $"%ClickLabel"


func _ready():
	connect("pressed", self, "_on_pressed")
	GlobalSignals.connect("sentence_checker", self, "_sentence_check")
#	connect("mouse_entered", self, "_on_entered")
#	connect("mouse_exited", self, "_on_exit")
	GlobalSignals.connect("boy_clicks", self, "boy_clicks")
	GlobalSignals.connect("item_placed_on_shelf", self, "_placed_on_shelf")
	$"%ObjectInfo".setup_label(object_text)
	
func boy_clicks(count):
	clicks.visible = true
	click_label.text = "Clicked = "+str(count)
	if count == 2:
		clicks.visible = false

func _on_pressed():
	print ("top pressed")
	
#	if GlobalVars.last_clicked == object_text and object_text in GlobalVars.current_sentence:
#		GlobalSignals.emit_signal("object_button_pressed")
#		if GlobalVars.tutorial_active:
#			print (" so curr sent "+GlobalVars.current_sentence)
#			if GlobalVars.current_sentence == "Give the medicine to the boy" and GlobalVars.boy_waiting:
#				GlobalSignals.emit_signal("button_pressed", object_text+"second")
#	else:
	if GlobalVars.tutorial_active:
		if GlobalVars.current_sentence == "Give the medicine to" and GlobalVars.boy_waiting:
			GlobalSignals.emit_signal("button_pressed", object_text+"first")
	GlobalVars.last_clicked = object_text
	if !GlobalVars.text_typing:
		if object_text in GlobalVars.current_sentence:
			GlobalSignals.emit_signal("object_button_pressed")
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
		GlobalSignals.emit_signal("object_button_pressed")		

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
			GlobalSignals.emit_signal("speak", "I can't take the boy!")
		give:
			return
#			var dist_player = GlobalVars.the_drone.position.distance_to(GlobalVars.the_player.position)
#			if dist_player > 200:
#				_get_closer_to_player()
#				return
#			GlobalSignals.emit_signal("add_to_inventory_bar_from_drone", object_text)
#			GlobalSignals.emit_signal("sentence_clear")
		use:
			GlobalSignals.emit_signal("speak", "You need to get it first.")
		use_on:
			return
		look:
			GlobalSignals.emit_signal("speak", "The boy is really unwell.")
		_:
			return
#			if not "shelf" in sentence:
#				GlobalSignals.emit_signal("speak", "I can't do that with the "+object_text)


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
	
