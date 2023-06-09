extends TextureButton

var is_inventory_item:= false

var object_text := "the climbing gloves"

var the_player: KinematicBody2D

var is_on_shelf := false

var is_active = true

var state := "null"

var inventory_alt := "res://assets/inventory_images/inventory_glove.png"

func _ready():
	connect("pressed", self, "_on_pressed")
	GlobalSignals.connect("sentence_checker", self, "_sentence_check")
#	connect("mouse_entered", self, "_on_entered")
#	connect("mouse_exited", self, "_on_exit")

func set_inventory_image():
	texture_normal = load(inventory_alt)

func _on_pressed():
	if GlobalVars.last_clicked == object_text:
		GlobalSignals.emit_signal("object_button_pressed")
	else:
		GlobalVars.last_clicked = object_text
		if object_text in GlobalVars.current_sentence:
			return
		GlobalSignals.emit_signal("update_on_hover", object_text)		


func _sentence_check(sentence):
	sentence = sentence.to_lower().strip_edges(true, true)
	if !is_active:
		return
	var get := "get "+object_text
	var look := "look at "+object_text
	var use := "use "+object_text
	var give := "give "+object_text
	var put_on := "put on "+object_text
	var take_off := "take off "+object_text
	var wear := "wear "+object_text		

	if not object_text in sentence:
		return	
	match sentence:
		get:
			if !is_inventory_item:
				if !GlobalVars.check_drone_inventory():
					return
				var dist = rect_position.distance_to(GlobalVars.current_player.position)
				if dist > 200:
					_get_closer()
					return
				GlobalSignals.emit_signal("add_to_inventory_bar", object_text)
				GlobalSignals.emit_signal("sentence_clear")
				if is_on_shelf:
					GlobalSignals.emit_signal("remove_from_shelf", object_text)
				GlobalSignals.emit_signal("remove_from_game_objects", object_text)
				queue_free()
			else:
				GlobalSignals.emit_signal("speak", "You already have it.")
		put_on:
			if !is_inventory_item:
				GlobalSignals.emit_signal("speak", "I need to get " + object_text +" first.")
				return
			if GlobalVars.wearing_gloves:
				GlobalSignals.emit_signal("speak", "I am already wearing "+object_text+".")
			else:
				if GlobalVars.remove_worn_items():
					GlobalVars.wearing_gloves = true
					GlobalSignals.emit_signal("wear_gloves", true)
					GlobalSignals.emit_signal("speak", "I put on "+object_text+".")
		take_off:
			if GlobalVars.wearing_gloves:
				GlobalVars.wearing_gloves = false
				GlobalSignals.emit_signal("wear_gloves", false)
				GlobalSignals.emit_signal("speak", "I took off "+object_text+".")	
			else:
				GlobalSignals.emit_signal("speak", "I am not wearing "+object_text+".")
		use:
			if !is_inventory_item:
				GlobalSignals.emit_signal("speak", "I need to get " + object_text +" first.")
				return
			if GlobalVars.wearing_gloves:
					GlobalSignals.emit_signal("speak", "I am already wearing "+object_text+".")
			else:
				if GlobalVars.remove_worn_items():
					GlobalVars.wearing_gloves = true
					GlobalSignals.emit_signal("wear_gloves", true)
					GlobalSignals.emit_signal("speak", "I put on "+object_text+".")
		wear:
			if !is_inventory_item:
				GlobalSignals.emit_signal("speak", "I need to get " + object_text +" first.")
				return
			if GlobalVars.wearing_gloves:
					GlobalSignals.emit_signal("speak", "I am already wearing "+object_text+".")
			else:
				if GlobalVars.remove_worn_items():
					GlobalVars.wearing_gloves = true
					GlobalSignals.emit_signal("wear_gloves", true)
					GlobalSignals.emit_signal("speak", "I put on "+object_text+".")
		give:
			var dist_player = GlobalVars.the_drone.position.distance_to(GlobalVars.the_player.position)
			if dist_player > 200:
				_get_closer_to_player()
				return
			GlobalSignals.emit_signal("add_to_inventory_bar_from_drone", object_text)
			GlobalSignals.emit_signal("sentence_clear")
		look:
			GlobalSignals.emit_signal("speak", "A pair of climbing gloves")
		_:
			if not "shelf" in sentence:
				GlobalSignals.emit_signal("speak", "I can't do that with the "+object_text)


func _get_closer():
	GlobalSignals.emit_signal("speak", "I need to get closer.")

func _check_can_remove():
	if GlobalVars.object_used_up and is_inventory_item:
		GlobalVars.object_used_up = false
		GlobalSignals.emit_signal("sentence_clear")	
		queue_free()


func _get_closer_to_player():
	GlobalSignals.emit_signal("speak", "The drone needs to be closer to me.")


