extends TextureButton


var is_inventory_item:= false

export var object_text: String

var the_player: KinematicBody2D

#onready var set_position = $Position2D

export var shelf_item: String
export var shelf_no: int

export var crystal_colour: String

var state := "null"

func _ready():
	connect("pressed", self, "_on_pressed")
	GlobalSignals.connect("sentence_checker", self, "_sentence_check")
	GlobalSignals.connect("close_hole", self, "_close_hole")
	GlobalSignals.connect("update_to_collect", self, "_update_to_collect")
#	connect("mouse_entered", self, "_on_entered")
#	connect("mouse_exited", self, "_on_exit")
	match crystal_colour:
		"yellow":
			$"%Crystal".texture = load("res://assets/platformer/Yellow Crystal.png")
		"green":
			$"%Crystal".texture = load("res://assets/platformer/Green Crystal.png")
		"red":
			$"%Crystal".texture = load("res://assets/platformer/Red Crystal.png")
		"blue":
			$"%Crystal".texture = load("res://assets/platformer/Blue Crystal.png")
	_update_to_collect()

func _update_to_collect():
	var to_collect = 0
	match crystal_colour:
		"yellow":
			to_collect =  GlobalVars.total_yellow_crystals - GlobalVars.collected_yellow_crystals
		"green":
			to_collect =  GlobalVars.total_green_crystals - GlobalVars.collected_green_crystals
		"red":
			to_collect =  GlobalVars.total_red_crystals - GlobalVars.collected_red_crystals
		"blue":
			to_collect =  GlobalVars.total_blue_crystals - GlobalVars.collected_blue_crystals
	$"%Count".text = str(to_collect)
	if to_collect == 0:
		$"%HoleAnim".play("close")
	GlobalVars.check_all_crystal_holes()

	

func _on_pressed():
#	if GlobalVars.last_clicked == object_text:		
#		GlobalSignals.emit_signal("object_button_pressed")
#	else:
	GlobalVars.last_clicked = object_text
	if object_text in GlobalVars.current_sentence:
		GlobalSignals.emit_signal("object_button_pressed")
		return
	GlobalSignals.emit_signal("update_on_hover", object_text)
	GlobalSignals.emit_signal("object_button_pressed")


#func _on_entered():
#	if object_text in GlobalVars.current_sentence:
#		return	
#	GlobalSignals.emit_signal("update_on_hover", object_text)
#
#func _on_exit():
#	GlobalSignals.emit_signal("remove_object")


func _sentence_check(sentence):
	sentence = sentence.to_lower().strip_edges(true, true)
	if not object_text in sentence:
		return
	var item_on_shelf = "use "+ shelf_item + " in the hole"
	var look = "look at "+object_text
	var crystal_to_hole = "use the "+ crystal_colour +" crystal in "+object_text
	print ("CTH "+crystal_to_hole)
	match sentence:
		crystal_to_hole:
			print (crystal_colour+ " into hole "+str(GlobalVars.collected_yellow_crystals))
			GlobalSignals.emit_signal("remove_crystal", crystal_colour)
			GlobalSignals.emit_signal("save_sentence", "use crystal hole")
#			GlobalVars.remove_crystal(crystal_colour)
			return
		"get the hole":
			GlobalSignals.emit_signal("speak", "I cannot get that.")
		"use the hole":
			GlobalSignals.emit_signal("speak", "I need to put an item in it.")		
#		item_on_shelf:
#			if the_player == null:
#				the_player = get_parent().return_player()
#			var dist = rect_position.distance_to(the_player.position)
#			print (dist)
#			if dist > 200:
#				_get_closer()
#				return
#			print ("correct item")				
#			GlobalSignals.emit_signal("sentence_clear")

		look:
			GlobalSignals.emit_signal("speak", "I need to put the correct item here.")
			GlobalSignals.emit_signal("sentence_clear")
#		_:
#			if "in "+object_text in sentence :
#				var dist = rect_position.distance_to(GlobalVars.current_player.position)
#				if dist > 450:
#					_get_closer()
#					return
#				GlobalSignals.emit_signal("place_on_shelf", sentence, shelf_no)
#				GlobalSignals.emit_signal("sentence_clear")
##				GlobalSignals.emit_signal("save_sentence", sentence)
##				print ("saving sentence "+sentence)
#				return
#			GlobalSignals.emit_signal("speak", "I can't do that.")
#			GlobalSignals.emit_signal("sentence_clear")


func _get_closer():
	GlobalSignals.emit_signal("speak", "I need to get closer.")


func _close_hole():
	$"%HoleCloseAnim".play("close")
