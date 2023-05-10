extends Panel

onready var sentence_label = $SentenceLabel
var starter_verb: String = ""
var added_extra: String = ""

var mouse_over := false

var text_input := false

var prepositions := ["in","on","to","with"] 


func _ready():
	GlobalSignals.connect("sentence_clear", self, "_clear")
	GlobalSignals.connect("sentence_bar_update", self, "_sentence_bar_update")
	GlobalSignals.connect("to_click_mode", self, "_to_click_mode")
	GlobalSignals.connect("to_text_mode", self, "_to_text_mode")
#	$"%SentenceLabel".editable = false
	$"%SentenceLabel".selecting_enabled = false
	
func _input(event):
	if GlobalVars.using_drone:
		return
	if event.is_action_released("left_click"):
		if mouse_over == true:
			GlobalSignals.emit_signal("object_button_pressed")
	elif event.is_action_pressed("ui_accept"):
		toggle_input_method_enter_key()
	elif event is InputEventKey and GlobalVars.text_typing:
#		print(char(event.unicode))
		GlobalVars.current_sentence += char(event.unicode)

func toggle_input_method_enter_key():
#	if !text_input:
#		text_input = true
#		$InputType.pressed = true
#	else:
	if sentence_label.text.strip_edges(true, true).length()==0:
		text_input = false
		$InputType.pressed = false
	else:
		GlobalVars.current_sentence = sentence_label.text
		if !GlobalSentences.sentence_check(GlobalVars.current_sentence):
			GlobalSignals.emit_signal("sentence_checker", GlobalVars.current_sentence)

func toggle_input_method():
	if text_input:
#		$"%SentenceLabel".editable = true
		$"%SentenceLabel".selecting_enabled = true
		GlobalVars.text_typing = true
		sentence_label.grab_focus()
		GlobalSignals.emit_signal("pause_player_movement", true)
		GlobalSignals.emit_signal("show_object_labels", true)
		GlobalSignals.emit_signal("sentence_clear")
		$"%TextWarn".visible = true
		GlobalSignals.emit_signal("speak", "Text entry mode.")
	else:
#		$"%SentenceLabel".editable = false
		$"%SentenceLabel".selecting_enabled = false
		GlobalVars.text_typing = false
		var current_focus_control = get_focus_owner()
		if current_focus_control:
			current_focus_control.release_focus()
		GlobalSignals.emit_signal("pause_player_movement", false)
		GlobalSignals.emit_signal("show_object_labels", false)
		$"%TextWarn".visible = false
		GlobalSignals.emit_signal("speak", "Click mode.")		

func start_sentence(word: String):
	starter_verb = word
	GlobalVars.current_sentence = starter_verb
	sentence_label.text = starter_verb



func add_to_sentence(word: String, extra: String):
	if GlobalVars.text_typing:
		GlobalVars.current_sentence = sentence_label.text
		var length = GlobalVars.current_sentence.length()-1
		var last = GlobalVars.current_sentence.substr(length, 1)
		if last != " ":
			GlobalVars.current_sentence += " "
		GlobalVars.current_sentence += word
		sentence_label.text = GlobalVars.current_sentence
		return

	added_extra = extra
	var regex_prep = RegEx.new()
#	|(?<=in).
	regex_prep.compile("(?<=in$).|(?<=to$).")
	var result_prep = regex_prep.search(GlobalVars.current_sentence)	 
#	print (GlobalVars.current_sentence)
#	print (result_prep)
	if result_prep != null:
		remove_object()
	GlobalVars.current_sentence += " "+word + added_extra
	GlobalVars.last_added = " "+word+added_extra
	sentence_label.text = GlobalVars.current_sentence

func _sentence_bar_update():
	print (GlobalVars.current_sentence)
	sentence_label.text = GlobalVars.current_sentence
	

func remove_object():
	GlobalVars.current_sentence = GlobalVars.current_sentence.replace(GlobalVars.last_added,"")
	print (GlobalVars.current_sentence)
	sentence_label.text = GlobalVars.current_sentence

func _clear():
	GlobalVars.using_preposition = false
	starter_verb = ""
	GlobalVars.current_sentence = ""
	sentence_label.text = GlobalVars.current_sentence

func submit_sentence():
	if starter_verb == "" and not GlobalVars.text_typing:
		return
#	MyFirebaseFunctions.send_action(current_sentence+added_extra)
	if !GlobalSentences.sentence_check(GlobalVars.current_sentence):
		GlobalSignals.emit_signal("sentence_checker", GlobalVars.current_sentence)
	


func _on_SentencePanel_mouse_entered():
	mouse_over = true


func _on_SentencePanel_mouse_exited():
	mouse_over = false


func _on_InputType_toggled(button_pressed):
	text_input = button_pressed
	toggle_input_method()

func _to_click_mode():
	text_input = false
	toggle_input_method()

func _to_text_mode():
	text_input = false
	toggle_input_method()
