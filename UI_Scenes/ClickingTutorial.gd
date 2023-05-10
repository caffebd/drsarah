extends Control


var made_sentence := ""

onready var sentence = $"%LineEdit"

var last_item := ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func add_to_sentence(word):
	print (made_sentence)
	print (last_item)
	made_sentence = made_sentence.replace(" "+last_item,"")
	print (made_sentence)
	made_sentence += " "+word
	sentence.text = made_sentence
	last_item = word
	if made_sentence == "Get the medicine":
		$"%MedicineInventory".visible = true
		$"%Medicine".visible = false
		$"%Medicine".disabled = true
	if made_sentence == "Push the lever":
		$"%lever".play("on")
		$"%door".play("open")


func _on_GetBtn_pressed():
	made_sentence = "Get"
	sentence.text = made_sentence


func _on_PushBtn_pressed():
	made_sentence = "Push"
	sentence.text = made_sentence


func _on_Medicine_pressed():
	add_to_sentence("the medicine")


func _on_Lever_pressed():
	add_to_sentence("the lever")
	
func reset():
	$"%lever".play("off")
	$"%door".play("closed")
	$"%MedicineInventory".visible = false
	$"%Medicine".visible = true
	$"%Medicine".disabled = false
