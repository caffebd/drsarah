extends TextureButton

var is_inventory_item:= false

var object_text := "the apple"

var the_player: KinematicBody2D

var is_on_shelf := false

var is_active = true

var state := "null"

var inventory_alt := "res://assets/inventory_images/inventory_apple.png"

func _ready():
	connect("pressed", self, "_on_pressed")
	GlobalSignals.connect("sentence_checker", self, "_sentence_check")
#	connect("mouse_entered", self, "_on_entered")
#	connect("mouse_exited", self, "_on_exit")
	GlobalSignals.connect("item_placed_on_shelf", self, "_placed_on_shelf")
	$"%ObjectInfo".setup_label(object_text)

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
		GlobalSignals.emit_signal("clicker")
		if is_inventory_item and "Use" in GlobalVars.current_sentence:
			GlobalSignals.emit_signal("update_on_hover", object_text, " on")
#			GlobalSignals.emit_signal("add_with_preposition","on")
			GlobalVars.using_preposition = true
		elif is_inventory_item and "Give" in GlobalVars.current_sentence:
			GlobalSignals.emit_signal("update_on_hover", object_text, " to")
			
		else:
			GlobalSignals.emit_signal("update_on_hover", object_text)		

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
	var look := "look at "+object_text
	var use := "use "+object_text
	var use_on := "use "+object_text+" on"
	var give := "give "+object_text +" to"	
	var on_shelf_1 := "use "+object_text+" on the first shelf"
	var on_shelf_2 := "use "+object_text+" on the second shelf"
	var on_shelf_3 := "use "+object_text+" on the third shelf"
	if not object_text in sentence or state == "off":
		return
	match sentence:
		get:
			if !is_inventory_item:
#				if the_player == null:
#					the_player = get_parent().get_parent().return_player()
				if !GlobalVars.check_drone_inventory():
					return
				var dist = rect_position.distance_to(GlobalVars.current_player.position)
				if dist > 400:
					_get_closer()
					return
				GlobalSignals.emit_signal("save_sentence", sentence)
				GlobalSignals.emit_signal("add_to_inventory_bar", object_text)
				GlobalSignals.emit_signal("sentence_clear")
				GlobalSignals.emit_signal("collector")
				print ("Bc on shelf is "+str(is_on_shelf))
				if is_on_shelf:
					print ("blue c on shelf")
					GlobalSignals.emit_signal("remove_from_shelf", object_text)
				GlobalSignals.emit_signal("remove_from_game_objects", object_text)
				queue_free()
			else:
				GlobalSignals.emit_signal("speak", "I already have it.")
		give:
			var dist_player = GlobalVars.the_drone.position.distance_to(GlobalVars.the_player.position)
			if dist_player > 200:
				_get_closer_to_player()
				return
			GlobalSignals.emit_signal("add_to_inventory_bar_from_drone", object_text)
			GlobalSignals.emit_signal("sentence_clear")
		use:
			GlobalSignals.emit_signal("speak", "I need to get it first.")
		use_on:
			return
		"give the apple to the creature":
			_check_can_remove()
		look:
			GlobalSignals.emit_signal("speak", "It's amazing that this apple looks so fresh.")
		_:
			if not "shelf" in sentence:
				GlobalSignals.emit_signal("speak", "I can't do that with the "+object_text)



func _get_closer():
	print ("GET CLOSER")
	GlobalSignals.emit_signal("speak", "I need to get closer.")
	
func _get_closer_to_player():
	GlobalSignals.emit_signal("speak", "The drone needs to be closer to me.")


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
		
func set_state(new_state):
	state = new_state
	
