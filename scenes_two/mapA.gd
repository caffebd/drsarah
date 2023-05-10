extends TileMap

onready var visibility_notifier:= $VisibilityNotifier2D

func _ready():
	visible = false


func _on_VisibilityNotifier2D_screen_entered():
	visible = true
	GlobalVars.active_map = name
	print (GlobalVars.active_map +" is now active")


func _on_VisibilityNotifier2D_screen_exited():
	visible = false
	print (GlobalVars.active_map +" was exited")
