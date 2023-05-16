extends TextureButton

var is_inventory_item:= false

export var object_text := "the alpha door"

export var key_needed := "the alpha key"

var the_player: KinematicBody2D

var is_on_shelf := false

var is_active = true

var state := "off"

var open_key_image := ""

onready var door_body = $DoorArea/DoorCollision

var off_image := "res://assets/game_objects/metal_door_4.png"
var on_image := "res://assets/game_objects/metal_door_open.png"

var alpha_image_closed := "res://assets/game_objects/Keys/Key 1 Small.png"
var bravo_image_closed := "res://assets/game_objects/Keys/Key 2 Small.png"
var delta_image_closed := "res://assets/game_objects/Keys/Key 3 Small.png"

var alpha_image_open := "res://assets/game_objects/Keys/Key 1.png"
var bravo_image_open := "res://assets/game_objects/Keys/Key 2.png"
var delta_image_open := "res://assets/game_objects/Keys/Key 3.png"

func _ready():
	$"%DoorAnim".play("closed")
	connect("pressed", self, "_on_pressed")
	GlobalSignals.connect("sentence_checker", self, "_sentence_check")
#	connect("mouse_entered", self, "_on_entered")
#	connect("mouse_exited", self, "_on_exit")
	GlobalSignals.connect("item_placed_on_shelf", self, "_placed_on_shelf")
	GlobalSignals.connect("glass_box_broken", self, "_remove_me")
	if state == "on":
#		texture_normal = load(on_image)
		door_body.disabled = true
	else:
#		texture_normal = load(off_image)
		door_body.disabled = false
	match key_needed:
		"the alpha key":
			$"%KeyType".texture = load(alpha_image_closed)
			open_key_image = "res://assets/game_objects/Keys/Key 1.png"
		"the beta key":
			$"%KeyType".texture = load(bravo_image_closed)
			open_key_image = "res://assets/game_objects/Keys/Key 2.png"
		"the delta key":
			$"%KeyType".texture = load(delta_image_closed)
			open_key_image = "res://assets/game_objects/Keys/Key 3.png"
			


func _on_pressed():
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
		GlobalSignals.emit_signal("object_button_pressed")	
#
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
	var open:= "open " + object_text
	var use := "use "+object_text
	var use_hammer := "use the hammer on "+object_text
	var use_key := "use "+key_needed +" on "+object_text
	var use_on := "use "+object_text+" on"	
	var on_shelf := "use "+object_text+" on the shelf"
	if not object_text in sentence:
		return
	match sentence:
		get:
			GlobalSignals.emit_signal("speak", "I cannot get this.")
		use:
			GlobalSignals.emit_signal("speak", "It needs a fuse.")
		open:
			GlobalSignals.emit_signal("speak", "It's open. It just needs a fuse.")	
		use_on:
			return
		use_hammer:
			GlobalSignals.emit_signal("speak", "That's not going to open it. It needs a key.")	
		use_key:
			GlobalSignals.emit_signal("speak", "It's open.")			
			set_state("on")
		look:
			GlobalSignals.emit_signal("speak", "It says "+object_text+".")
	
		_:
			GlobalSignals.emit_signal("speak", "I can't do that with the "+object_text)


func set_state(fuse_state):
	state = fuse_state
	if state == "on":
		$"%KeyType".texture = load(open_key_image)
#		texture_normal = load(on_image)
		$"%DoorAnim".play("open")
		door_body.disabled = true
		GlobalSignals.emit_signal("save_sentence", object_text+" opened")
	else:
#		texture_normal = load(off_image)
		door_body.disabled = false
		
		

	
		
func _get_closer():
	GlobalSignals.emit_signal("speak", "I need to get closer.")

func _check_can_remove():
	if GlobalVars.object_used_up and is_inventory_item:
		GlobalVars.object_used_up = false
		GlobalSignals.emit_signal("sentence_clear")	
		queue_free()

func _placed_on_shelf(the_item):
	if the_item == object_text:
		if !is_on_shelf:
			GlobalSignals.emit_signal("remove_from_game_objects", object_text)
			queue_free()

func _remove_me():
	GlobalSignals.emit_signal("remove_from_game_objects", object_text)
	queue_free()
