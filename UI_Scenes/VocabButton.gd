extends TextureButton

export var my_word: String = ""

func _ready():
	$btn_label.text = my_word

func _on_VocabButton_pressed():
	GlobalVars.using_preposition = false
	GlobalVars.last_clicked = ""
	GlobalSignals.emit_signal("vocab_button_pressed", my_word)
	GlobalSignals.emit_signal("clicker")
	if GlobalVars.tutorial_active:
		GlobalSignals.emit_signal("button_pressed", my_word)
		
