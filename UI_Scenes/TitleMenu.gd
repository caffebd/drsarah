extends Control


var next_screen = "res://UI_Scenes/LibraryLoginMenu.tscn"

onready var start_btn = $"%StartButton"

func _ready():
	start_btn.grab_focus()

func _on_StartButton_pressed():
	get_tree().change_scene(next_screen)
