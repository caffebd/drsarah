extends Panel

onready var sentence_label = $SentenceLabel
var starter_verb: String = ""
var added_extra: String = ""

var mouse_over := false


func _ready():
	GlobalSignals.connect("sentence_clear", self, "_clear")

func _input(event):
	if !GlobalVars.using_drone:
		return
	if event.is_action_released("left_click"):
		if mouse_over == true:
			GlobalSignals.emit_signal("object_button_pressed")

func start_sentence(word: String):
	if GlobalVars.current_sentence == "Shutdown" and word == "Shutdown":
		GlobalSignals.emit_signal("object_button_pressed")
	starter_verb = word
	GlobalVars.current_sentence = starter_verb
	sentence_label.text = starter_verb

func add_to_sentence(word: String, extra: String):
	added_extra = extra
	print ("current sent len "+str(GlobalVars.current_sentence.length()) )
	if GlobalVars.current_sentence.length() > starter_verb.length() and word != "on":
		print ("too long")
		if !"on" in GlobalVars.current_sentence:
			GlobalVars.current_sentence = starter_verb
	GlobalVars.current_sentence += " "+word + added_extra
	GlobalVars.last_added = " "+word+added_extra
	sentence_label.text = GlobalVars.current_sentence

func remove_object():
	GlobalVars.current_sentence = GlobalVars.current_sentence.replace(GlobalVars.last_added,"")
	sentence_label.text = GlobalVars.current_sentence

func _clear():
	GlobalVars.using_preposition = false
	starter_verb = ""
	GlobalVars.current_sentence = ""
	sentence_label.text = GlobalVars.current_sentence

func submit_sentence():
	if starter_verb == "":
		return
#	MyFirebaseFunctions.send_action(current_sentence+added_extra)
	GlobalSignals.emit_signal("sentence_checker", GlobalVars.current_sentence)
	


func _on_SentencePanel_mouse_entered():
	mouse_over = true


func _on_SentencePanel_mouse_exited():
	mouse_over = false
