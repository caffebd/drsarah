extends Node


func sentence_check(sentence)->bool:
	sentence = sentence.to_lower().strip_edges(true, true)
	match sentence:
		"dance":
			print ("dance here")
			GlobalSignals.emit_signal("dance")
			GlobalSignals.emit_signal("sentence_clear")
			return true
		"xyzzy":
			GlobalSignals.emit_signal("xyzzy")
			GlobalSignals.emit_signal("sentence_clear")
			return true
		"help":
			GlobalSignals.emit_signal("speak","I need to read the sign and find an object that answers the riddle. When I find the object, I need to put it in the hole.")
			GlobalSignals.emit_signal("sentence_clear")
			return true
		"what is your name?":
			GlobalSignals.emit_signal("speak","My name is Dr. Sarah Bari")
			return true
		"what is your name":
			GlobalSignals.emit_signal("speak","My name is Dr. Sarah Bari")
			return true
		"how old are you?":
			GlobalSignals.emit_signal("speak","I am 27 years old.")
			return true
		"how old are you":
			GlobalSignals.emit_signal("speak","I am 27 years old.")
			return true			 
		"what is your favourite colour":
			GlobalSignals.emit_signal("speak","My favourite colour is purple.")
			return true		
		"what is your favourite colour?":
			GlobalSignals.emit_signal("speak","My favourite colour is purple.")
			return true		
		"what is your favorite color?":
			GlobalSignals.emit_signal("speak","My favourite colour is purple.")
			return true
		"what is your favorite color":
			GlobalSignals.emit_signal("speak","My favourite colour is purple.")
			return true
		"orville":
			GlobalSignals.emit_signal("i_can_fly")
			GlobalSignals.emit_signal("to_click_mode")
			return true
		"jay garrick":
			GlobalSignals.emit_signal("speedster")
			GlobalSignals.emit_signal("to_click_mode")
			return true
		"escher":
			GlobalSignals.emit_signal("gravity_change", "down")
			GlobalSignals.emit_signal("to_click_mode")
			return true
		"berg":
			GlobalSignals.emit_signal("saw_the_sign")	
			GlobalSignals.emit_signal("to_click_mode")
			return true
		"pogo":
			GlobalSignals.emit_signal("pogo")	
			GlobalSignals.emit_signal("to_click_mode")
			return true												
		_:
			return false



#git remote add origin https://github.com/caffebd/drsarah.git
#git branch -M main
#git push -u origin main
