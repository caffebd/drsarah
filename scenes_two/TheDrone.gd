extends TextureButton

var is_inventory_item:= false

var object_text := "the drone"

var the_player: KinematicBody2D

var is_on_shelf := false

var is_active = true

var state := "null"

var inventory_alt := "res://assets/inventory_images/inventory_drone.png"

func _ready():
	connect("pressed", self, "_on_pressed")
	GlobalSignals.connect("sentence_checker", self, "_sentence_check")
	$"%ObjectInfo".setup_label(object_text)
#	connect("mouse_entered", self, "_on_entered")
#	connect("mouse_exited", self, "_on_exit")


func _on_pressed():
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

func _sentence_check(sentence):
	sentence = sentence.to_lower().strip_edges(true, true)
	if !is_active:
		return
	var get := "get "+object_text
	var look := "look at "+object_text
	var use := "use "+object_text

	if not object_text in sentence:
		return	
	match sentence:
		get:
			if !is_inventory_item:
				if the_player == null:
					the_player = get_parent().get_parent().return_player()
				var dist = rect_position.distance_to(the_player.position)
				if dist > 200:
					_get_closer()
					return
				GlobalSignals.emit_signal("add_to_inventory_bar", object_text)
				GlobalSignals.emit_signal("sentence_clear")
				if is_on_shelf:
					GlobalSignals.emit_signal("remove_from_shelf", object_text)
				GlobalSignals.emit_signal("remove_from_game_objects", object_text)
				GlobalSignals.emit_signal("save_sentence", sentence)
				GlobalSignals.emit_signal("collector")
				queue_free()
			else:
				GlobalSignals.emit_signal("speak", "You already have it.")
		use:
			if !is_inventory_item:
				GlobalSignals.emit_signal("speak", "I need to get it first")
				return
				
			if !GlobalVars.using_drone:
					GlobalVars.using_drone = true
					GlobalSignals.emit_signal("release_drone", true)
					
		look:
			GlobalSignals.emit_signal("speak", "A drone... this could be useful.")
		_:
			if not "shelf" in sentence:
				GlobalSignals.emit_signal("speak", "I can't do that with "+object_text)


func _get_closer():
	GlobalSignals.emit_signal("speak", "I need to get closer.")

func _check_can_remove():
	if GlobalVars.object_used_up and is_inventory_item:
		GlobalVars.object_used_up = false
		GlobalSignals.emit_signal("sentence_clear")	
		queue_free()




