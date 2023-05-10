extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"



func _on_MenuBtn_pressed():
	get_tree().change_scene("res://UI_Scenes/LevelSelect.tscn")
