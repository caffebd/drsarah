extends Control


var made_sentence := ""

onready var sentence = $"%LineEdit"

var last_item := ""

# Called when the node enters the scene tree for the first time.
func _ready():
	$"%LineEdit".grab_focus()

func line_focus():
	$"%LineEdit".grab_focus()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		print ($"%LineEdit".text)
		var sentence = $"%LineEdit".text.strip_edges(true, true).to_lower()
		if sentence == "get the clock":
			$"%ClockInventory".visible = true
			$"%Clock".visible = false
			$"%Clock".disabled = true
			$"%LineEdit".text = ""
			sentence = ""
		if sentence == "push the button":
			$"%lever".play("on")
			$"%door".play("open")
			$"%LineEdit".text = ""
			sentence = ""
			

func add_to_sentence(word):
	print (made_sentence)
	print (last_item)
	made_sentence = made_sentence.replace(" "+last_item,"")
	print (made_sentence)
	made_sentence += " "+word
	sentence.text = made_sentence
	last_item = word
	if made_sentence == "Get the clock":
		$"%ClockInventory".visible = true
		$"%Clock".visible = false
		$"%Clock".disabled = true
	if made_sentence == "Push the lever":
		$"%Button".play("on")
		$"%door".play("open")



	
func reset():
	$"%lever".play("off")
	$"%door".play("closed")
	$"%ClockInventory".visible = false
	$"%Clock".visible = true
	$"%Clock".disabled = false
