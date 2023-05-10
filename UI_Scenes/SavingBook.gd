extends Node2D


onready var timer = $"%SaveTimer"
onready var book_anim = $"%save_book_anim"


# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalSignals.connect("save_sentence",self, "_saving_status")

func _saving_status(sentence):
	print ("SAVIG BOOK YES")
	book_anim.play("saving")
	visible = true
	$"%save_chime".play()
#	timer.start()



func _on_save_chime_finished():
	book_anim.stop()
	visible = false
