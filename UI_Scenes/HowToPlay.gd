extends Control


onready var labels_grid := $"%LabelsList"

var buttons = ["Movement", "Click", "Type"]

onready var tutorial_panels = [$"%MovementTutorial",$"%Clicking",$"%Typing" ]


# Called when the node enters the scene tree for the first time.
func _ready():
	var button_scene = load("res://UI_Scenes/TutorialButton.tscn")
	for btn in buttons:
		var new_btn = button_scene.instance()
		new_btn.set_up_button(btn)
		labels_grid.add_child(new_btn)
		new_btn.connect("pressed", self, "_on_pressed", [btn])
		if btn == "Movement":
			new_btn.selected(true)
		
func _on_pressed(btn: String):
	for other_btn in $"%LabelsList".get_children():
		print (other_btn.my_label)
		print (btn)
		if other_btn.my_label != btn:
			other_btn.selected(false)
		else:
			other_btn.selected(true)
	$"%Clicking".reset()			
	for tut in tutorial_panels:
		tut.visible = false
	if btn == "Movement":
		$"%MovementTutorial".visible = true
	if btn == "Click":	
		$"%Clicking".visible = true
	if btn == "Type":	
		$"%Typing".visible = true
		$"%Typing".line_focus()
		
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_backBtn_pressed():
	get_tree().change_scene("res://UI_Scenes/LevelSelect.tscn")
