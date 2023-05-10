extends Area2D


var tween: SceneTreeTween

onready var up_arrow := $UpArrow

export(String) var to_level = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_EntryDoor_body_entered(body):
	if body.name == "PlayerGirl":
		up_arrow.visible = true
		animate_arrow()
		GlobalSignals.emit_signal("touching_door", true, to_level, true)
	
func animate_arrow():	
		tween = create_tween()
		tween.tween_property($UpArrow, "scale", Vector2(0.35, 0.35), 0.8)
		tween.tween_property($UpArrow, "scale", Vector2(0.3, 0.3), 0.8)
		$ArrowTimer.start()


func _on_ArrowTimer_timeout():
	animate_arrow()


func _on_EntryDoor_body_exited(body):
	if body.name == "PlayerGirl":
		up_arrow.visible = true
		animate_arrow()
		GlobalSignals.emit_signal("touching_door", false, to_level, true)
