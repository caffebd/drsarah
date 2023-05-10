extends TextureButton

var is_inventory_item:= false

var object_text := "the diving mask"

var a_text := "a diving mask"

var the_player: KinematicBody2D

var is_on_shelf := false

var is_active = true

var state := "null"

var inventory_alt := "res://assets/inventory_images/inventory_mask.png"

func _ready():
	connect("pressed", self, "_on_pressed")
	GlobalSignals.connect("sentence_checker", self, "_sentence_check")
	$"%ObjectInfo".setup_label(object_text)
#	connect("mouse_entered", self, "_on_entered")
#	connect("mouse_exited", self, "_on_exit")


func _on_pressed():
	GlobalVars.last_clicked = object_text
	if !GlobalVars.text_typing:
		if object_text in GlobalVars.current_sentence:
			GlobalSignals.emit_signal("object_button_pressed")
			return
	GlobalSignals.emit_signal("clicker")
	GlobalSignals.emit_signal("update_on_hover", object_text)
	GlobalSignals.emit_signal("object_button_pressed")		

func set_inventory_image():
	texture_normal = load(inventory_alt)

func _sentence_check(sentence):
	sentence = sentence.to_lower().strip_edges(true, true)
	if !is_active:
		return
	var get := "get "+object_text
	var take := "take "+object_text
	var pick_up := "pick up "+object_text
	var look := "look at "+object_text
	var use := "use "+object_text
	var give := "give "+object_text
	var put_on := "put on "+object_text
	var take_off := "take off "+object_text
	var wear := "wear "+object_text	

	if not object_text in sentence:
		return
	print (sentence)	
	match sentence:
		get:
			get_item(sentence)
		take:
			get_item(sentence)
		pick_up:
			get_item(sentence)

		put_on:
			if !is_inventory_item:
				GlobalSignals.emit_signal("speak", "I need to get " + object_text +" first.")
				return
			if GlobalVars.wearing_mask:
				GlobalSignals.emit_signal("speak", "I am already wearing the mask.")
			else:
				if GlobalVars.remove_worn_items():
					GlobalVars.wearing_mask = true
					GlobalSignals.emit_signal("wear_mask", true)
					GlobalSignals.emit_signal("speak", "I put on "+object_text+".")
		take_off:
			if GlobalVars.wearing_mask:
				if GlobalVars.the_player.swimming:
					GlobalSignals.emit_signal("speak", "I can't take off the mask while I am diving.")
					return
				GlobalVars.wearing_mask = false
				GlobalSignals.emit_signal("wear_mask", false)
				GlobalSignals.emit_signal("speak", "I took off the diving mask.")	
			else:
				GlobalSignals.emit_signal("speak", "I am not wearing "+object_text+".")
		use:
			if !is_inventory_item:
				GlobalSignals.emit_signal("speak", "I need to get " + object_text +" first.")
				return
			if GlobalVars.wearing_mask:
					GlobalSignals.emit_signal("speak", "I am already wearing the mask.")
			else:
				if GlobalVars.remove_worn_items():
					GlobalVars.wearing_mask = true
					GlobalSignals.emit_signal("wear_mask", true)
					GlobalSignals.emit_signal("speak", "I put on the diving mask.")
		wear:
			if !is_inventory_item:
				GlobalSignals.emit_signal("speak", "I need to get " + object_text +" first.")
				return
			if GlobalVars.wearing_mask:
					GlobalSignals.emit_signal("speak", "I am already wearing "+object_text+".")
			else:
				if GlobalVars.remove_worn_items():
					GlobalVars.wearing_mask = true
					GlobalSignals.emit_signal("wear_mask", true)
					GlobalSignals.emit_signal("speak", "I put on "+object_text+".")
		give:
			var dist_player = GlobalVars.the_drone.position.distance_to(GlobalVars.the_player.position)
			if dist_player > 200:
				_get_closer_to_player()
				return
			GlobalSignals.emit_signal("add_to_inventory_bar_from_drone", object_text)
			GlobalSignals.emit_signal("sentence_clear")
		look:
			GlobalSignals.emit_signal("speak", "A diving mask. I can go underwater with this.")
		_:
			if not "shelf" in sentence:
				GlobalSignals.emit_signal("speak", "I can't do that with "+object_text)

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
		GlobalSignals.emit_signal("add_to_inventory_bar", object_text)
		GlobalSignals.emit_signal("sentence_clear")
		GlobalSignals.emit_signal("speak", "It’s a diving mask. I can use this to swim underwater.")
		if is_on_shelf:
			GlobalSignals.emit_signal("remove_from_shelf", object_text)
		GlobalSignals.emit_signal("remove_from_game_objects", object_text)
		GlobalSignals.emit_signal("save_sentence", sentence)
		GlobalSignals.emit_signal("collector")
		queue_free()
	else:
		GlobalSignals.emit_signal("speak", "You already have it.")


func _get_closer():
	GlobalSignals.emit_signal("speak", "I need to get closer.")

func _check_can_remove():
	if GlobalVars.object_used_up and is_inventory_item:
		GlobalVars.object_used_up = false
		GlobalSignals.emit_signal("sentence_clear")	
		queue_free()


func _get_closer_to_player():
	GlobalSignals.emit_signal("speak", "The drone needs to be closer to me.")



