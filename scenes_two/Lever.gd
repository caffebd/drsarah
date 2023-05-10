extends TextureButton

var is_inventory_item:= false

export var object_text := "the lever"

var the_player: KinematicBody2D

var is_on_shelf := false

var state := "off"

var lever_pos := "off"

var is_active = true

var needs_fuse := false

var is_broken := false

export(NodePath) var linked_box_path = ""

var linked_box: TextureButton

export (NodePath) var activate_object_path = ""
var activate_object

onready var clicks := $"%Clicks"
onready var click_label := $"%ClicksLabel"

func _ready():
	connect("pressed", self, "_on_pressed")
	GlobalSignals.connect("sentence_checker", self, "_sentence_check")
	GlobalSignals.connect("lever_clicks", self, "lever_clicks")
	GlobalSignals.connect("lever_broken", self, "_lever_broken")
#	connect("mouse_entered", self, "_on_entered")
#	connect("mouse_exited", self, "_on_exit")
	if linked_box_path !="":
		linked_box = get_node(linked_box_path)
		needs_fuse = true
	if activate_object_path !="":
		activate_object = get_node(activate_object_path)
	
	$"%ObjectInfo".setup_label(object_text)

	set_state(state)



func set_state(the_state):
	lever_pos = state
	_check_fuse()
#	$LevelAnim.set_animation(lever_pos)
#	$LevelAnim.play()
	
func _lever_broken(name, broken):
	if name == object_text:
		is_broken = broken

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
#	$"%Reminder".start()
	GlobalVars.last_clicked = object_text
	if object_text in GlobalVars.current_sentence:
		GlobalSignals.emit_signal("object_button_pressed")
		return
	GlobalSignals.emit_signal("clicker")
	if is_inventory_item and "Use" in GlobalVars.current_sentence and GlobalVars.current_sentence.length():
		GlobalSignals.emit_signal("update_on_hover", object_text, " on")
#			GlobalSignals.emit_signal("add_with_preposition","on")
		GlobalVars.using_preposition = true
	else:
		GlobalSignals.emit_signal("update_on_hover", object_text)
		GlobalSignals.emit_signal("object_button_pressed")		

func lever_clicks(count):
	clicks.visible = true
	click_label.text = "Clicked = "+str(count)
	if count == 2:
		clicks.visible = false

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
			GlobalSignals.emit_signal("speak", "I cannot pick up the lever.")
		use:
			if GlobalVars.tutorial_active:
				return
			if is_broken:
				GlobalSignals.emit_signal("speak", "It seems to be broken.")
				return
			var dist = rect_global_position.distance_to(GlobalVars.current_player.global_position)
			print (dist)
			if dist > 350:
				_get_closer()
				return
			if lever_pos == "on":
				lever_pos = "off"
				state = "off"
			else:
				lever_pos = "on"
				state = "on"										
			_check_fuse()
		pull:
			if GlobalVars.tutorial_active:
				return
			if is_broken:
				GlobalSignals.emit_signal("speak", "It seems to be broken.")
				return
			var dist = rect_global_position.distance_to(GlobalVars.current_player.global_position)
			if dist > 350:
				_get_closer()
				return
			if lever_pos == "off":
				GlobalSignals.emit_signal("speak", "The lever is already off, try pushing it")	
			else:
				lever_pos = "off"
				state = "off"			
				_check_fuse()
		push:
			if is_broken:
				GlobalSignals.emit_signal("speak", "It seems to be broken.")
				return
			var dist = rect_global_position.distance_to(GlobalVars.current_player.global_position)
			print ("Lever dist "+str(dist))
			if dist > 350:
				_get_closer()
				return
			if lever_pos == "on":
				GlobalSignals.emit_signal("speak", "The lever is already on, try pulling it")	
			else:
				lever_pos = "on"
				state = "on"			
				_check_fuse()
		use_on:
			return
		look:
			if is_broken:
				GlobalSignals.emit_signal("speak", "It seems to be broken.")
				return
			GlobalSignals.emit_signal("speak", "The lever is "+lever_pos)
		_:
			GlobalSignals.emit_signal("speak", "I can't do that with the "+object_text)

func _check_fuse():
	print (needs_fuse)
	if needs_fuse:
		print ("fuse box is "+linked_box.state)
		if linked_box.state == "on":
			_switch()
		else:
			$LevelAnim.set_animation("no_power")
			$LevelAnim.play()
			yield(get_tree().create_timer(0.5), "timeout")
			GlobalSignals.emit_signal("speak", "Nothing happened. I think it needs power."+linked_box.name )
			$LevelAnim.set_animation(lever_pos)
			$LevelAnim.play()
	else:
		_switch()
			

func _switch():
	print ("in switch "+lever_pos)
	$LevelAnim.set_animation(lever_pos)
	$LevelAnim.play()
	state = lever_pos
	GlobalSignals.emit_signal("save_sentence", object_text+" moved "+state)
	if activate_object_path != "":
		activate_object.set_state(lever_pos)
#	GlobalSignals.emit_signal("move_log", lever_pos, "the old log")

func _get_closer():
	GlobalSignals.emit_signal("speak", "I need to get closer.")



func _on_Reminder_timeout():
	GlobalSignals.emit_signal("speak", "Click again. Remember to click two times to complete your sentence.")

