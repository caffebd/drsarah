extends TextureButton


var is_inventory_item:= false

var object_text := "the ladder"

var the_player: KinematicBody2D

var is_on_shelf := false

var is_active = true

var state := "null"

var a_text := "a ladder"

var inventory_alt := "res://assets/inventory_images/ladder_inventory.png"

func _ready():
	connect("pressed", self, "_on_pressed")
	GlobalSignals.connect("sentence_checker", self, "_sentence_check")
#	connect("mouse_entered", self, "_on_entered")
#	connect("mouse_exited", self, "_on_exit")
	$"%ObjectInfo".setup_label(object_text)
	if is_inventory_item:
		print ("ladder inv")
		$Ladder.queue_free()

func _on_pressed():
#	if GlobalVars.last_clicked == object_text:
#		GlobalSignals.emit_signal("object_button_pressed")
#		$"%Reminder".stop()
#	else:
	GlobalVars.last_clicked = object_text
	if object_text in GlobalVars.current_sentence:
		GlobalSignals.emit_signal("object_button_pressed")
		return
#	$"%Reminder".start()
	GlobalSignals.emit_signal("clicker")
	GlobalSignals.emit_signal("update_on_hover", object_text)
	GlobalSignals.emit_signal("object_button_pressed")		

func set_inventory_image():
	texture_normal = load(inventory_alt)
	$"%LadderAnim".playing = false
	$"%LadderAnim".visible=false
	rect_min_size = Vector2(125,125)
	rect_size = Vector2(125,125)

#func _on_entered():
#	if object_text in GlobalVars.current_sentence:
#		return
#	GlobalSignals.emit_signal("update_on_hover", object_text)
#
#func _on_exit():
#	if !is_inventory_item:
#		GlobalSignals.emit_signal("remove_object")	

func _sentence_check(sentence):
	sentence = sentence.to_lower().strip_edges(true, true)
	var give := "give "+object_text	
	if not object_text in sentence:
		return
	match sentence:
		"get the ladder":
			if !is_inventory_item:
				if !GlobalVars.check_drone_inventory():
					return

#				var dist = rect_position.distance_to(GlobalVars.current_player.position)
#				print (dist)
#				if dist > 5000:
#					_get_closer()
#					return
				if !GlobalVars.carried_inventory.has("the ladder"):
					GlobalSignals.emit_signal("save_sentence", "found a ladder")
				GlobalSignals.emit_signal("add_to_inventory_bar", object_text)
				GlobalSignals.emit_signal("sentence_clear")
				GlobalSignals.emit_signal("remove_from_game_objects", object_text)
				GlobalSignals.emit_signal("collector")

				if GlobalVars.ladder_never_got:
					GlobalVars.ladder_never_got = false
					GlobalSignals.emit_signal("speak", "It’s a ladder.")
					
				queue_free()
			else:
				print ("tut active is "+str(GlobalVars.tutorial_active))
				if GlobalVars.tutorial_active:
					print ("send buuton pressed")
					GlobalSignals.emit_signal("button_pressed", "ladderinv")
#				GlobalSignals.emit_signal("summon_ladder")
##				GlobalSignals.emit_signal("speak", "You already have it.")
		"use the ladder":
			if is_inventory_item:
				GlobalSignals.emit_signal("drop_ladder")
				GlobalSignals.emit_signal("sentence_clear")
#				GlobalSignals.emit_signal("remove_from_inventory_list", object_text)
#				queue_free()
		give:
			var dist_player = GlobalVars.the_drone.position.distance_to(GlobalVars.the_player.position)
			if dist_player > 200:
				_get_closer_to_player()
				return
			GlobalSignals.emit_signal("add_to_inventory_bar_from_drone", object_text)
			GlobalSignals.emit_signal("sentence_clear")
		"look at the ladder":
			GlobalSignals.emit_signal("speak", "It’s a ladder.")
		_:
			GlobalSignals.emit_signal("speak", "I can't do that.")


func _get_closer():
	GlobalSignals.emit_signal("speak", "I need to get closer.")


func _on_Ladder_body_entered(body):
	if (body.name == "PlayerGirl"):
		print (get_parent().name)
		GlobalVars.active_map = get_parent().name
		GlobalSignals.emit_signal("can_climb", true, "climb_ladder")


func _on_Ladder_body_exited(body):
	if (body.name == "PlayerGirl"):
		GlobalSignals.emit_signal("can_climb", false, "climb_ladder")

func _get_closer_to_player():
	GlobalSignals.emit_signal("speak", "The drone needs to be closer to me.")


func _on_Reminder_timeout():
	GlobalSignals.emit_signal("speak", "Click again. Remember to click two times to complete your sentence.")
