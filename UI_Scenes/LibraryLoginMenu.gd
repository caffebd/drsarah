extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var library_name := $"%LibraryName"
onready var card_entry := $"%LibraryCard"
onready var submit := $"%Submit"



# Called when the node enters the scene tree for the first time.
func _ready():
	card_entry.grab_focus()


func _input(event):
	if Input.is_action_pressed("ui_accept"):
		_on_Submit_pressed()
		return
	if 	$"%error".visible:
		if event is InputEventKey and event.pressed:
			$"%error".visible = false
			card_entry.grab_focus()


func _on_Submit_pressed():
	var card_no_temp = card_entry.text.strip_edges(true, true).to_lower()
	var card_no = card_no_temp.replace(" ","")
	card_entry.text = card_no
	print (card_no)
	var regex_a = RegEx.new()
	regex_a.compile("\\d{6}$")
	
#	var regex_b = RegEx.new()
#	regex_b.compile("(26401\\d{10})$")
#	var regex_c = RegEx.new()
#	regex_c.compile("(uh\\d{5})$")
	
	var result_a = regex_a.search(card_no)
#	var result_b = regex_b.search(card_no)
#	var result_c = regex_c.search(card_no)
	
	if result_a != null:
		print ("login with "+result_a.get_string())
		begin_login(result_a.get_string())
#	elif result_b != null:
#		print ("login with "+result_b.get_string())
#		begin_login(result_b.get_string())
#	elif result_c != null:
#		print ("login with "+result_c.get_string())
#		begin_login(result_c.get_string())
	else:
		$"%error".visible = true
		print ("NO MATCH")

func begin_login(number):
	var email = number+"@caffebd.org"
	var password = number 
	$"%LoadTimer".start()
	var login = yield (FirebaseRest.login(email, password), "completed")
	if login:
		$"%LoadTimer".stop()
		print ("logged in "+FirebaseRest.user_info.id)
		get_tree().change_scene("res://UI_Scenes/LevelSelect.tscn")
	else:
		var register = yield (FirebaseRest.register(email, password), "completed")
		if register:
			$"%LoadTimer".stop()
			print ("registered in "+FirebaseRest.user_info.id)
			get_tree().change_scene("res://UI_Scenes/LevelSelect.tscn")



#	var regex_a = RegEx.new()
#	regex_a.compile("(26401\\d{9})$")
#	var regex_b = RegEx.new()
#	regex_b.compile("(26401\\d{10})$")
#	var regex_c = RegEx.new()
#	regex_c.compile("(uh\\d{5})$")


func _on_LoadTimer_timeout():
	$"%LoadingAnim".play("loading")
	$"%LoadingAnim".visible = true


#func _on_touch_trigger_pressed():
#	if OS.has_feature('JavaScript'):
#		find_node("LoginLineEdit").text = JavaScript.eval("""
#		window.prompt('Library Card')
#	""")
