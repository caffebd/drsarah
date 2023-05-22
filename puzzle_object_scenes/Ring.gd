extends TextureButton

var is_inventory_item:= false

export var object_text := "the ring"

var a_text :="a ring."

var the_player: KinematicBody2D

var is_on_shelf := false

var is_active = true

var state := "null"

var inventory_alt := "res://assets/inventory_images/inventory_ring.png"

func _ready():
	connect("pressed", self, "_on_pressed")
	GlobalSignals.connect("sentence_checker", self, "_sentence_check")
#	connect("mouse_entered", self, "_on_entered")
#	connect("mouse_exited", self, "_on_exit")
	GlobalSignals.connect("item_placed_on_shelf", self, "_placed_on_shelf")
	GlobalSignals.connect("vanish_an_item", self, "_vanish_an_item")
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
	print (GlobalVars.current_sentence)
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
	var get_from_hole := "get from hole "+object_text
	var give_elder := "give "+object_text+ " to the village elder"
	var on_shelf_1 := "use "+object_text+" in the hole"
	var on_shelf_2 := "use "+object_text+" in the second hole"
	if not object_text in sentence or state == "off":
		return
	match sentence:
		get:
			get_item(sentence)
		take:
			get_item(sentence)
		pick_up:
			get_item(sentence)
		get_from_hole:
			get_item_from_hole(sentence)
		give:
			var dist_player = GlobalVars.the_drone.position.distance_to(GlobalVars.the_player.position)
			print (dist_player)
			if dist_player > 400:
				_get_closer_to_player()
				return
			GlobalSignals.emit_signal("add_to_inventory_bar_from_drone", object_text)
			GlobalSignals.emit_signal("sentence_clear")
		use:
			if !is_inventory_item:
				GlobalSignals.emit_signal("speak", "You need to get it first.")
			else:
				GlobalSignals.emit_signal("speak", "I need to use it 'IN' something.")
		on_shelf_1:
			return
		look:
			GlobalSignals.emit_signal("speak", "It's "+a_text)
		_:
			if not "hole" in sentence:
				GlobalSignals.emit_signal("speak", "I can't do that with it.")

func get_item(sentence):
	if !is_inventory_item:
#				if the_player == null:
#					the_player = get_parent().get_parent().return_player()
		if !GlobalVars.check_drone_inventory():
			return
		var dist = rect_position.distance_to(GlobalVars.current_player.position)
		print (dist)
		if dist > 600:
			_get_closer()
			return
		
		GlobalSignals.emit_signal("add_to_inventory_bar", object_text)
		GlobalSignals.emit_signal("sentence_clear")
		GlobalSignals.emit_signal("speak", "It’s "+a_text+".")
		if is_on_shelf:
			GlobalSignals.emit_signal("remove_from_shelf", object_text)
		GlobalSignals.emit_signal("remove_from_game_objects", object_text)
		GlobalSignals.emit_signal("save_sentence", sentence)
		queue_free()
	else:
		GlobalSignals.emit_signal("speak", "You already have it.")

func get_item_from_hole(sentence):
	GlobalSignals.emit_signal("add_to_inventory_bar", object_text)
	GlobalSignals.emit_signal("sentence_clear")
	if is_on_shelf:
		GlobalSignals.emit_signal("remove_from_shelf", object_text)
	GlobalSignals.emit_signal("remove_from_game_objects", object_text)
	queue_free()		
		
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
	
func _vanish_an_item(item):
	if item == object_text:
		queue_free()
