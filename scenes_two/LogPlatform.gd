extends TextureButton

var is_inventory_item:= false

export var object_text := "the old log"

var the_player: KinematicBody2D

var is_on_shelf := false

var is_active = true

var state := "off"

export var y_pos_change :float
export var x_pos_change :float

var move_to_x := 0.0
var move_to_y := 0.0

var start_x := 0.0
var start_y := 0.0

func _ready():
	connect("pressed", self, "_on_pressed")
	GlobalSignals.connect("sentence_checker", self, "_sentence_check")
#	connect("mouse_entered", self, "_on_entered")
#	connect("mouse_exited", self, "_on_exit")
#	GlobalSignals.connect("move_log", self, "_move_log")
	move_to_x = rect_position.x + x_pos_change
	move_to_y = rect_position.y + y_pos_change
	start_x = rect_position.x
	start_y = rect_position.y
	
	

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
	var on_shelf := "use "+object_text+" on the shelf"
	if not object_text in sentence:
		return
	match sentence:
		get:
			GlobalSignals.emit_signal("speak", "I cannot pick up a log!")
		use:
			GlobalSignals.emit_signal("speak", "I think there is a lever to move the log.")
		use_on:
			return
		"pull the old log":
			GlobalSignals.emit_signal("speak", "I think there is a lever to move the log.")
		"push the old log":
			GlobalSignals.emit_signal("speak", "I think there is a lever to move the log.")
		look:
			GlobalSignals.emit_signal("speak", "A large log. Useful for walking over.")
		_:
			GlobalSignals.emit_signal("speak", "I can't do that with the "+object_text)


func _get_closer():
	GlobalSignals.emit_signal("speak", "I need to get closer.")

func set_state(new_state):
	print ("log state "+new_state)
	state = new_state
	var tween = create_tween()
	if state == "on":
		tween.tween_property(self, "rect_position", Vector2(move_to_x, move_to_y), 3.0 )
	else:
		tween.tween_property(self, "rect_position", Vector2(start_x, start_y), 3.0 )


#func _move_log(state: String, this_log: String):
#	if object_text != this_log:
#		return
#	var tween = create_tween()
#	if state == "on":
#		tween.tween_property(self, "rect_position", Vector2(move_to_x, move_to_y), 3.0 )
#	else:
#		tween.tween_property(self, "rect_position", Vector2(start_x, start_y), 3.0 )
