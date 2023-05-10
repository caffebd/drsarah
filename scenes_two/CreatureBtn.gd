extends TextureButton

var is_inventory_item:= false

var object_text := "the creature"

var the_player: KinematicBody2D

var is_on_shelf := false

var is_active = true

var state := "null"

func _ready():
	connect("pressed", self, "_on_pressed")



func _on_pressed():
	get_parent()._was_pressed()
