extends TextureButton

var is_inventory_item:= false

export var object_text := "the push button"

var the_player: KinematicBody2D

var is_on_shelf := false

var state := "off"

var button_pos := "off"

var is_active = true

var needs_fuse := false

export(NodePath) var linked_box_path = ""

export var active_time := 10

var linked_box: TextureButton

export (NodePath) var activate_object_path = ""
var activate_object

var push_sentence_saved := false

var first_run = true

func _ready():
	connect("pressed", self, "_on_pressed")
	GlobalSignals.connect("sentence_checker", self, "_sentence_check")
	GlobalSignals.connect("lever_clicks", self, "lever_clicks")
	GlobalSignals.connect("Timeup", self, "_timeup")
#	connect("mouse_entered", self, "_on_entered")
#	connect("mouse_exited", self, "_on_exit")
	if linked_box_path !="":
		linked_box = get_node(linked_box_path)
		needs_fuse = true
	if activate_object_path !="":
		activate_object = get_node(activate_object_path)
	
	$"%ObjectInfo".setup_label(object_text)

	set_state(state)

func _timeup():
	var new_state = "off"
	button_pos = "off"
	set_state(new_state)


func set_state(the_state):
	state = the_state
	match state:
		"on":
			texture_normal = load("res://assets/game_objects/push_on.png")
			GlobalSignals.emit_signal("start_countdown", active_time)
		"off":
			texture_normal = load("res://assets/game_objects/push_off.png")
	print ("Button is now"+state)
	
	if activate_object_path != "" and not first_run:
		print ("calling from button in set state"+str(state))
		activate_object.set_state(state)
	first_run = false

func _on_pressed():
#	if GlobalVars.last_clicked == object_text:
#		GlobalSignals.emit_signal("object_button_pressed")
#		$"%Reminder".stop()
#		if GlobalVars.tutorial_active:
#			if GlobalVars.current_sentence == "Push the lever":
#				GlobalSignals.emit_signal("button_pressed", object_text+"second")
#	else:
	if GlobalVars.tutorial_active:
		if GlobalVars.current_sentence == "Push":
			GlobalSignals.emit_signal("button_pressed", object_text+"first")
	GlobalVars.last_clicked = object_text
	if object_text in GlobalVars.current_sentence:
		GlobalSignals.emit_signal("object_button_pressed")
		return
	if is_inventory_item and "Use" in GlobalVars.current_sentence and GlobalVars.current_sentence.length():
		GlobalSignals.emit_signal("update_on_hover", object_text, " on")
#			GlobalSignals.emit_signal("add_with_preposition","on")
		GlobalVars.using_preposition = true
	else:
		GlobalSignals.emit_signal("update_on_hover", object_text)
		GlobalSignals.emit_signal("object_button_pressed")		



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
	var pull := "pull "+object_text
	var push := "push "+object_text
	var use_on := "use "+object_text+" on"	
	var on_shelf := "use "+object_text+" on the shelf"
	if not object_text in sentence:
		return
	match sentence:
		get:
			GlobalSignals.emit_signal("speak", "I cannot pick up the button.")
			GlobalSignals.emit_signal("sentence_clear")
		use:
			if GlobalVars.tutorial_active:
				return
			var dist = rect_global_position.distance_to(GlobalVars.current_player.global_position)
			print (dist)
			if dist > 350:
				_get_closer()
				return			
			_check_fuse()
		pull:
			if GlobalVars.tutorial_active:
				return
			GlobalSignals.emit_signal("speak", "I think I need to push this button.")
			GlobalSignals.emit_signal("sentence_clear")	
#			var dist = rect_position.distance_to(GlobalVars.current_player.position)
#			if dist > 1200:
#				_get_closer()
#				return
#			if button_pos == "off":
#				GlobalSignals.emit_signal("speak", "The lever is off, try pushing it")	
#			else:
#				_check_fuse()
		push:
			if GlobalVars.tutorial_active:
				return
			var dist = rect_global_position.distance_to(GlobalVars.current_player.global_position)
			print (dist)
			if dist > 350:
				_get_closer()
				return			
			_check_fuse()
		use_on:
			return
		look:
			GlobalSignals.emit_signal("speak", "The button is "+button_pos+".")
			GlobalSignals.emit_signal("sentence_clear")
		_:
			GlobalSignals.emit_signal("speak", "I can't do that with the "+object_text)

func _check_fuse():
	print ("checking fuse "+str(needs_fuse))
	if needs_fuse:
		print ("fuse box is "+linked_box.state)
		if linked_box.state == "on":
			_switch()
		else:
			$LevelAnim.set_animation("no_power")
			$LevelAnim.play()
			yield(get_tree().create_timer(0.5), "timeout")
			GlobalSignals.emit_signal("speak", "Nothing happened. I think it needs power."+linked_box.name )
			GlobalSignals.emit_signal("sentence_clear")
	else:
		_switch()
			

func _switch():
	print ("in switch "+button_pos)
	if button_pos == "off":
		button_pos = "on"
		if GlobalVars.button_never_pushed:
			GlobalVars.button_never_pushed = false
			GlobalSignals.emit_signal("speak", "I need to be quick.")
			GlobalSignals.emit_signal("sentence_clear")
		if !push_sentence_saved:
			push_sentence_saved = true
			GlobalSignals.emit_signal("save_sentence", "push button on")	
	else:
		button_pos = "off"
		print ("call timeup")
#		GlobalSignals.emit_signal("Timeup")
	state = button_pos
	set_state(button_pos)
#	if activate_object_path != "":
#		print ("calling from button "+str(button_pos))
#		activate_object.set_state(button_pos)

#	GlobalSignals.emit_signal("move_log", lever_pos, "the old log")

func _get_closer():
	GlobalSignals.emit_signal("speak", "I need to get closer.")




func _on_Reminder_timeout():
	GlobalSignals.emit_signal("speak", "Click again. Remember to click two times to complete your sentence.")
