extends TextureButton

var is_inventory_item:= false

export var object_text := "the secret rock"

export var rock_secret := ""

var the_player: KinematicBody2D



func _ready():
	connect("pressed", self, "_on_pressed")
	GlobalSignals.connect("sentence_checker", self, "_sentence_check")
	$"%ObjectInfo".setup_label(object_text)
#	connect("mouse_entered", self, "_on_entered")
#	connect("mouse_exited", self, "_on_exit")


func _on_pressed():
#	if GlobalVars.last_clicked == object_text:		
#		GlobalSignals.emit_signal("object_button_pressed")
#		$"%ReminderClick".stop()
#	else:
	GlobalVars.last_clicked = object_text
	if object_text in GlobalVars.current_sentence:
		GlobalSignals.emit_signal("object_button_pressed")
		return
	GlobalSignals.emit_signal("update_on_hover", object_text)
	GlobalSignals.emit_signal("object_button_pressed")

#func _on_entered():
#	if GlobalVars.no_click:
#		return
#	if object_text in GlobalVars.current_sentence:
#		return
#	GlobalSignals.emit_signal("update_on_hover", object_text)
#
#func _on_exit():
#	if !is_inventory_item:
#		GlobalSignals.emit_signal("remove_object")	

func _sentence_check(sentence):
	sentence = sentence.to_lower().strip_edges(true, true)
	if not object_text in sentence:
		return
	var look := "look at "+object_text
	match sentence:
		look:
			var dist = rect_position.distance_to(GlobalVars.current_player.position)
			if dist > 300:
				_get_closer()
				return	
			GlobalSignals.emit_signal("save_sentence", rock_secret)
			GlobalSignals.emit_signal("speak", rock_secret)
			GlobalSignals.emit_signal("sentence_clear")
		_:
			GlobalSignals.emit_signal("speak", "I can't do that with the rock.")


func _get_closer():
	GlobalSignals.emit_signal("speak", "I need to get closer.")

func _check_can_remove():
	if GlobalVars.object_used_up and is_inventory_item:
		GlobalVars.object_used_up = false
		GlobalSignals.emit_signal("sentence_clear")	
		queue_free()
		

	

#if !is_inventory_item:
#	if the_player == null:
#		the_player = get_parent().return_player()
#	var dist = rect_position.distance_to(the_player.position)
#	print (dist)
#	if dist > 200:
#		_get_closer()
#		return

