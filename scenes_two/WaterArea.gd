extends Node2D

onready var water_base = $"%WaterBaseCollision"


func _ready():
	GlobalSignals.connect("wear_mask", self, "_is_diving")


func _on_WaterBody_body_entered(body):
	if body.name == "PlayerGirl":		
		GlobalSignals.emit_signal("water_entered")


func _on_WaterBody_body_exited(body):
	if body.name == "PlayerGirl":
		GlobalSignals.emit_signal("water_exited")

func _is_diving(state):
	water_base.disabled = state
