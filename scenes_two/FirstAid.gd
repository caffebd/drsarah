extends TextureButton

var is_inventory_item:= false

var object_text := "the medicine"

var inventory_alt := "res://assets/inventory_images/inventory_medicine.png"

var the_player: KinematicBody2D

var is_on_shelf := false

var is_active = true

var state := "null"

var 	boy_given := false
var girl_given := false	

var can_give := false	

onready var click_box = $"%ClickCount"
onready var click_counter = $"%clicks"

var click_int = 0

func _ready():
	connect("pressed", self, "_on_pressed")
	GlobalSignals.connect("sentence_checker", self, "_sentence_check")
#	connect("mouse_entered", self, "_on_entered")
#	connect("mouse_exited", self, "_on_exit")
	GlobalSignals.connect("item_placed_on_shelf", self, "_placed_on_shelf")
	GlobalSignals.connect("hand_over_box", self, "hand_over_box")
	GlobalSignals.connect("can_give_box", self, "_can_give_box")
	click_box.visible = false
	$"%ObjectInfo".setup_label(object_text)

func show_click_box():
	click_box.visible = false

func update_clicks():
	click_int += 1
	click_counter.text = "Clicks = "+str(click_int)

func set_inventory_image():
	texture_normal = load(inventory_alt)

func _on_pressed():
	print ("top pressed")
#	if GlobalVars.last_clicked == object_text and object_text in GlobalVars.current_sentence:
#		GlobalSignals.emit_signal("object_button_pressed")
#		if GlobalVars.tutorial_active and click_int == 1:
#			update_clicks()
#			GlobalSignals.emit_signal("button_pressed", "the medicinesecondget")
#	else:
	GlobalSignals.emit_signal("clicker")
	if GlobalVars.tutorial_active and GlobalVars.current_sentence == "Give":
		GlobalSignals.emit_signal("medicine_pressed")
	if GlobalVars.tutorial_active and not is_inventory_item:
		if click_int == 0:
			if "Get" in GlobalVars.current_sentence:
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


func _sentence_check(sentence):
	sentence = sentence.to_lower()
	var get := "get "+object_text
	var look := "look at "+object_text
	var use := "use "+object_text
	var use_on := "use "+object_text+" on"	
	var on_shelf_1 := "use "+object_text+" on the first shelf"
	var on_shelf_2 := "use "+object_text+" on the second shelf"
	var on_shelf_3 := "use "+object_text+" on the third shelf"
	var give_boy := "give "+object_text+" to the boy"
	var give_girl := "give "+object_text+" to the girl"
	var give_woman := "give "+object_text+" to the worried mother"	
	if not object_text in sentence or state == "off":
		return	
	match sentence:
		get:
			if !is_inventory_item:
				if !GlobalVars.check_drone_inventory():
					return
#				var dist = rect_position.distance_to(GlobalVars.current_player.position)
#				if dist > 200:
#					_get_closer()
#					return

				GlobalSignals.emit_signal("add_to_inventory_bar", object_text)
				GlobalSignals.emit_signal("sentence_clear")
				if is_on_shelf:
					GlobalSignals.emit_signal("remove_from_shelf", object_text)
				GlobalSignals.emit_signal("remove_from_game_objects", object_text)
				GlobalSignals.emit_signal("collector")
				queue_free()
			else:
				GlobalSignals.emit_signal("speak", "You already have it.")
		use:
			GlobalSignals.emit_signal("speak", "You need to get it first.")
		use_on:
			return
		"give the medicine to the worried mother":
			if GlobalVars.boy_waiting:
				GlobalSignals.emit_signal("speak", "I should give the medicine to the boy now.")
				GlobalSignals.emit_signal("remove_object")
				return
			if GlobalVars.girl_waiting:
				GlobalSignals.emit_signal("speak", "I should give the medicine to the girl now.")
				GlobalSignals.emit_signal("remove_object")
				return
		give_boy:
			print ("give boy "+str(GlobalVars.boy_waiting))
			if boy_given:
				GlobalSignals.emit_signal("speak", "The boy has already taken his medicine.")
				GlobalSignals.emit_signal("remove_object")
				return
			var dist_player = GlobalVars.the_player.position.distance_to(GlobalVars.the_player.position)
			if dist_player > 300:
				_get_closer()
				return
			if GlobalVars.boy_waiting:
				boy_given = true
				GlobalVars.boy_waiting = false
#				GlobalSignals.emit_signal("speak", "Take this. It will help you to feel better.")
				GlobalSignals.emit_signal("medicine_given")
			else:
				if !GlobalVars.girl_waiting and !GlobalVars.boy_waiting:
					GlobalSignals.emit_signal("speak", "I need to ask permission from a parent first.")
					GlobalSignals.emit_signal("sentence_clear")
				else:
					GlobalSignals.emit_signal("speak", "Now give some medicine to the girl.")
					GlobalSignals.emit_signal("remove_object")
		give_girl:
			if girl_given:
				GlobalSignals.emit_signal("speak", "The girl has already taken her medicine.")
				GlobalSignals.emit_signal("remove_object")
#				GlobalSignals.emit_signal("sentence_clear")
				return
			var dist_player = GlobalVars.the_player.position.distance_to(GlobalVars.the_player.position)
			if dist_player > 300:
				_get_closer()
				return
			if GlobalVars.girl_waiting:
				girl_given = true
				GlobalVars.girl_waiting = false
#				GlobalSignals.emit_signal("speak", "Take this medicine. It should help you get well.")
				GlobalSignals.emit_signal("medicine_given")
			else:
				if !GlobalVars.girl_waiting and !GlobalVars.boy_waiting:
					GlobalSignals.emit_signal("speak", "I need to get ask their parent first.")
					GlobalSignals.emit_signal("sentence_clear")
				else:
					GlobalSignals.emit_signal("speak", "I should give the medicine to the boy now.")
					GlobalSignals.emit_signal("remove_object")
		give_woman:
			if can_give:
				hand_over_box()
			else:
				GlobalSignals.emit_signal("speak", "I need this for the children")
		look:
			GlobalSignals.emit_signal("speak", "This is the medicine to treat TB. There is enough for the whole village." )
		_:
			if not "shelf" in sentence:
				GlobalSignals.emit_signal("speak", "I can't do that with the "+object_text)


func _get_closer():
	GlobalSignals.emit_signal("speak", "I need to get closer.")

func _check_can_remove():
	if is_inventory_item:
		GlobalSignals.emit_signal("sentence_clear")
		GlobalSignals.emit_signal("remove_from_inventory_list", object_text)
		queue_free()

func _placed_on_shelf(the_item):
	if the_item == object_text:
		if !is_on_shelf:
			GlobalSignals.emit_signal("remove_from_inventory_list", object_text)
			queue_free()

func _get_closer_to_player():
	GlobalSignals.emit_signal("speak", "The drone needs to be closer to me.")

func set_state(new_state):
	state = new_state

func hand_over_box():
	_check_can_remove()

func _can_give_box():
	can_give = true
