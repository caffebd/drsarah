extends TextureButton

var is_inventory_item:= false

var object_text := "the red crystal"

var the_player: KinematicBody2D

var is_on_shelf := false

var is_active = true

var state := "null"

var a_text = "a red crystal."

var inventory_count := 1

var inventory_alt := "res://assets/inventory_images/Inventory Red Crystal.png"

func _ready():
	connect("pressed", self, "_on_pressed")
	GlobalSignals.connect("sentence_checker", self, "_sentence_check")
#	connect("mouse_entered", self, "_on_entered")
#	connect("mouse_exited", self, "_on_exit")
	GlobalSignals.connect("item_placed_on_shelf", self, "_placed_on_shelf")
	$"%ObjectInfo".setup_label(object_text)

func _on_pressed():
	print ("top pressed")
#	if GlobalVars.last_clicked == object_text and object_text in GlobalVars.current_sentence:
#		GlobalSignals.emit_signal("object_button_pressed")
#	else:
	GlobalVars.last_clicked = object_text
	if !GlobalVars.text_typing:
		if object_text in GlobalVars.current_sentence:
			GlobalSignals.emit_signal("object_button_pressed")
			return
	GlobalSignals.emit_signal("clicker")
	if is_inventory_item and "Use" in GlobalVars.current_sentence:
		GlobalSignals.emit_signal("update_on_hover", object_text, " in")
#			GlobalSignals.emit_signal("add_with_preposition","on")
		GlobalVars.using_preposition = true
	elif is_inventory_item and "Give" in GlobalVars.current_sentence:
		GlobalSignals.emit_signal("update_on_hover", object_text, " to")
	else:
		GlobalSignals.emit_signal("update_on_hover", object_text)
		GlobalSignals.emit_signal("object_button_pressed")		

func set_inventory_image():
	texture_normal = load(inventory_alt)

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
	var use_on := "use "+object_text+" in"
	var give := "give "+object_text+" to dr. sarah"	
	var give_elder := "give "+object_text+ " to the village elder"
	var on_shelf_1 := "use "+object_text+" in the hole"
	var on_shelf_2 := "use "+object_text+" in the second hole"
	var on_shelf_3 := "use "+object_text+" in the third hole"
	if not object_text in sentence or state == "off":
		return
	match sentence:
		get:
			get_item(sentence)
		take:
			get_item(sentence)
		pick_up:
			get_item(sentence)
		give:
			var dist_player = GlobalVars.the_drone.position.distance_to(GlobalVars.the_player.position)
			if dist_player > 200:
				_get_closer_to_player()
				return
			GlobalSignals.emit_signal("add_to_inventory_bar_from_drone", object_text)
			GlobalSignals.emit_signal("sentence_clear")
		"give the red crystal to the village elder":
			if !is_inventory_item:
				GlobalSignals.emit_signal("speak", "I need to get it first.")
				return
			print ("curr lev "+GlobalVars.current_level)
			if GlobalVars.current_level == "VillageEnd":
				var elder = GlobalVars.the_player.get_parent().game_objects["the village elder"]
				var dist_player = GlobalVars.the_player.position.distance_to(elder.rect_position)
				print ("distance to elder "+str(dist_player))
				if dist_player > 400:
					_get_closer_to_player()
					return
				GlobalSignals.emit_signal("treasure_received")
				GlobalSignals.emit_signal("sentence_clear")
				_check_can_remove(sentence)
			else:
				GlobalSignals.emit_signal("speak", "The village elder is not here.")
		use:
			if !is_inventory_item:
				GlobalSignals.emit_signal("speak", "I need to get it first.")
			else:
				GlobalSignals.emit_signal("speak", "I need to use it 'IN' something.")
		use_on:
			return
		look:
			GlobalSignals.emit_signal("speak", "An incredible red crystal.")
		_:
			if not "shelf" in sentence or not "hole" in sentence:
				GlobalSignals.emit_signal("speak", "I can't do that with it.")

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
		GlobalSignals.emit_signal("speak", "It's "+a_text)
		if is_on_shelf:
			GlobalSignals.emit_signal("remove_from_shelf", object_text)
		GlobalSignals.emit_signal("remove_from_game_objects", object_text)
		GlobalSignals.emit_signal("save_sentence", sentence)
		GlobalSignals.emit_signal("collector")
		queue_free()
	else:
		GlobalSignals.emit_signal("speak", "You already have it.")
		
		
func _get_closer():
	print ("GET CLOSER")
	GlobalSignals.emit_signal("speak", "I need to get closer.")
	
func _get_closer_to_player():
	GlobalSignals.emit_signal("speak", "The drone needs to be closer to me.")


func _check_can_remove(sentence):
	if is_inventory_item:
		GlobalSignals.emit_signal("sentence_clear")
		GlobalSignals.emit_signal("remove_from_inventory_list", object_text)
		GlobalSignals.emit_signal("save_sentence", sentence)
		queue_free()

func _placed_on_shelf(the_item):
	if the_item == object_text:
		if !is_on_shelf:			
			GlobalSignals.emit_signal("remove_from_inventory_list", object_text)
			GlobalSignals.emit_signal("save_sentence", "use "+object_text+" in the hole")
			GlobalSignals.emit_signal("check_shelves", true)
			queue_free()
		
func set_state(new_state):
	state = new_state


func inventory_count(counter):
	if counter > 1:
		$"%count".text = str(counter)
		$"%count".visible = true
		inventory_count = counter
	else:
		$"%count".visible = false
