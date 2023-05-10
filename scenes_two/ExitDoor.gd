extends Area2D



onready var up_arrow := $"%UpArrow"

var door_open := false
var touching_door := false

var tween: SceneTreeTween

export (String) var to_level := ""

var save_on_door_open := true



func _ready():
	GlobalSignals.connect("open_door", self, "_set_open_door")
	GlobalSignals.connect("close_door", self, "_set_close_door")
	GlobalSignals.connect("changing_level", self, "_changing_level")

func _changing_level():
	$"%ArrowTimer".stop()
	
	
func _set_open_door(can_save):
	save_on_door_open = can_save
	if save_on_door_open:
		GlobalSignals.emit_signal("door_opened_now_save")
	$"%CollisionShape2D".disabled = true
	$"%DoorOpenSound".play()
	$"%DoorAnim".play("open")
	


func _set_close_door():
	door_open = false
	$"%DoorAnim".play("closed")

func _on_ExitDoor_body_entered(body):
	if body.name == "PlayerGirl":
		if door_open:
			up_arrow.visible = true
			touching_door = true
			animate_arrow()
			GlobalSignals.emit_signal("touching_door", true, to_level, false)
		else:
			GlobalSignals.emit_signal("speak", "The door is locked.")

func animate_arrow():	
		tween = create_tween()
		tween.tween_property($UpArrow, "scale", Vector2(0.3, 0.3), 0.8)
		tween.tween_property($UpArrow, "scale", Vector2(0.5, 0.5), 0.8)
#		$ArrowTimer.start()


func _on_ExitDoor_body_exited(body):
	if body.name == "PlayerGirl":
		GlobalSignals.emit_signal("touching_door", false, to_level, false)
		up_arrow.visible = false
		touching_door = false


func _on_ArrowTimer_timeout():
	animate_arrow()


func _on_DoorAnim_animation_finished():
#	print (" door done opening "+$"%DoorAnim".animation)
	if $"%DoorAnim".animation == "open":
		door_open = true
		$"%CollisionShape2D".disabled = false

