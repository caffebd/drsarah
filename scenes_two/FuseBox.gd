extends TextureButton

var is_inventory_item:= false

var object_text := "the fuse box"

var the_player: KinematicBody2D

var is_on_shelf := false

var is_active = true

var state := "off"

var off_image := "res://assets/platformer/fuse_box_off.png"
var on_image := "res://assets/platformer/fuse_box_on.png"

func _ready():
	connect("pressed", self, "_on_pressed")
	GlobalSignals.connect("sentence_checker", self, "_sentence_check")
#	connect("mouse_entered", self, "_on_entered")
#	connect("mouse_exited", self, "_on_exit")
	GlobalSignals.connect("item_placed_on_shelf", self, "_placed_on_shelf")
	GlobalSignals.connect("glass_box_broken", self, "_remove_me")
	if state == "on":
		texture_normal = load(on_image)
	else:
		texture_normal = load(off_image)


func _on_pressed():
	if GlobalVars.last_clicked == object_text:
		GlobalSignals.emit_signal("object_button_pressed")
	else:
		GlobalVars.last_clicked = object_text
		if object_text in GlobalVars.current_sentence:
			return
		if is_inventory_item and "Use" in GlobalVars.current_sentence and GlobalVars.current_sentence.length():
			GlobalSignals.emit_signal("update_on_hover", object_text, " on")
	#			GlobalSignals.emit_signal("add_with_preposition","on")
			GlobalVars.using_preposition = true
		else:
			GlobalSignals.emit_signal("update_on_hover", object_text)

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
	var use_on := "use "+object_text+" on"	
	var on_shelf := "use "+object_text+" on the shelf"
	if not object_text in sentence:
		return
	match sentence:
		get:
			GlobalSignals.emit_signal("speak", "I cannot get the fuse box.")
		use:
			GlobalSignals.emit_signal("speak", "It needs a fuse.")
		open:
			GlobalSignals.emit_signal("speak", "It's open. It just needs a fuse.")	
		use_on:
			return
		"use the hammer on the fuse box":
			GlobalSignals.emit_signal("speak", "That didn't help. It needs a fuse.")	
		"use the fuse on the fuse box":
			GlobalSignals.emit_signal("speak", "I think it's working now.")
			set_state("on")
		look:
			if state == "off":
				GlobalSignals.emit_signal("speak", "The fuse box is off. It needs a fuse.")
			else:
				GlobalSignals.emit_signal("speak", "The fuse box is on.")		
		_:
			GlobalSignals.emit_signal("speak", "I can't do that with the "+object_text)


func set_state(fuse_state):
	state = fuse_state
	if state == "on":
		texture_normal = load(on_image)
	else:
		texture_normal = load(off_image)
		
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
