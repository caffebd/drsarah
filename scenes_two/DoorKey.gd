extends TextureButton


var is_inventory_item:= false


export var object_text := "the alpha key"
export var my_door := "the alpha door"

var the_player: KinematicBody2D

var is_on_shelf := false

var is_active = true

var state := "null"

var start_x : float
var start_y : float
var move_to_x : float
var move_to_y : float



func _ready():
	connect("pressed", self, "_on_pressed")
	GlobalSignals.connect("sentence_checker", self, "_sentence_check")
	GlobalSignals.connect("bad_guy_fire", self, "_key_drop")
	start_x = rect_position.x
	start_y = rect_position.y
#	connect("mouse_entered", self, "_on_entered")
#	connect("mouse_exited", self, "_on_exit")
	match object_text:
		"the alpha key":
			texture_normal = load("res://assets/game_objects/alpha_key.png")
		"the bravo key":
			texture_normal = load("res://assets/game_objects/bravo_key.png")
		"the delta key":
			texture_normal = load("res://assets/game_objects/delta_key.png")


func set_inventory_image():
	match object_text:
		"the alpha key":
			texture_normal = load("res://assets/inventory_images/inventory_alpha_key.png")
		"the bravo key":
			texture_normal = load("res://assets/inventory_images/inventory_bravo_key.png")
		"the delta key":
			texture_normal = load("res://assets/inventory_images/inventory_delta_key.png")



func _on_pressed():
	print ("top pressed")
	if GlobalVars.last_clicked == object_text and object_text in GlobalVars.current_sentence:
		GlobalSignals.emit_signal("object_button_pressed")
	else:
		GlobalVars.last_clicked = object_text
		if !GlobalVars.text_typing:
			if object_text in GlobalVars.current_sentence:
				return
		GlobalSignals.emit_signal("clicker")
		if is_inventory_item and "Use" in GlobalVars.current_sentence:
			GlobalSignals.emit_signal("update_on_hover", object_text, " on")
#			GlobalSignals.emit_signal("add_with_preposition","on")
			GlobalVars.using_preposition = true
		elif is_inventory_item and "Give" in GlobalVars.current_sentence:
			GlobalSignals.emit_signal("update_on_hover", object_text, " to")
			
		else:
			GlobalSignals.emit_signal("update_on_hover", object_text)
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
	if not object_text in sentence:
		return
	var on_shelf_1 := "use "+object_text+" on the first shelf"
	var on_shelf_2 := "use "+object_text+" on the second shelf"
	var on_shelf_3 := "use "+object_text+" on the third shelf"
	var give := "give "+object_text +" to"	
	var get := "get "+object_text
	var look := "look at "+object_text
	var use_door := "use "+object_text+" on "+my_door
	match sentence:
		get:
			if !is_inventory_item:
				if !GlobalVars.check_drone_inventory():
					return
				if !GlobalVars.check_drone_inventory():
					return
				var dist = rect_position.distance_to(GlobalVars.current_player.position)
				print (dist)
				if dist > 400:
					_get_closer()
					return
				GlobalSignals.emit_signal("add_to_inventory_bar", object_text)
				GlobalSignals.emit_signal("sentence_clear")
				if is_on_shelf:
					GlobalSignals.emit_signal("remove_from_shelf", object_text)
				GlobalSignals.emit_signal("remove_from_game_objects", object_text)
				GlobalSignals.emit_signal("collector")
				queue_free()
			else:
				GlobalSignals.emit_signal("speak", "You already have it.")
#		"Use the fuse":
#			GlobalSignals.emit_signal("speak", "You need to get it first.")
#		"Use the fuse on the fuse box":
#			_check_can_remove()
#		"Use the fuse on":
#			return
		use_door:
			_check_can_remove()
		"use the old key on the padlock":
			return
		give:
			var dist_player = GlobalVars.the_drone.position.distance_to(GlobalVars.the_player.position)
			if dist_player > 200:
				_get_closer_to_player()
				return
			GlobalSignals.emit_signal("add_to_inventory_bar_from_drone", object_text)
			GlobalSignals.emit_signal("sentence_clear")
		look:
			GlobalSignals.emit_signal("speak", "It says "+object_text)
		_:
			if not "shelf" in sentence and not "fuse box" in sentence:
				GlobalSignals.emit_signal("speak", "I can't do that with "+object_text+".")


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

func _key_drop():
	visible = true
	disabled = false
	move_to_x = start_x + 450
	move_to_y = start_y + 400
	var tween = create_tween()
	tween.tween_property(self, "rect_position", Vector2(move_to_x, move_to_y), 0.5 )
