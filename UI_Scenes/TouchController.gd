extends CanvasLayer

var move_vector := Vector2(0,0)
var joystick_active := false


func _ready():
	var os = OS.get_name()
	print ("OS IS "+os)
	if GlobalVars.use_touch_controls:
		visible = true
	else:
		visible = false
#	$"%Label".text = os
#	if os == "Android" or os == "iOS":
#		use_touch = true
#	else:
#		visible = false
		

func _input(event):
	if !GlobalVars.use_touch_controls:
		return
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		if $"%TouchScreenButton".is_pressed():
			move_vector = calculate_move_vector(event.position)			
			joystick_active = true
#			$"%InnerCircle".position = event.position
			$"%InnerCircle".position.x = clamp(event.position.x,$"%TouchScreenButton".position.x+75, $"%TouchScreenButton".position.x+155 )
			$"%InnerCircle".position.y = clamp(event.position.y,$"%TouchScreenButton".position.y+75, $"%TouchScreenButton".position.y+155 )
	
		
	
	if event is InputEventScreenTouch:
		if event.pressed == false:
			joystick_active = false
			$"%InnerCircle".position.x = $"%TouchScreenButton".position.x + 115
			$"%InnerCircle".position.y = $"%TouchScreenButton".position.y + 115

func _physics_process(delta):
	if !GlobalVars.use_touch_controls:
		return
	if joystick_active:
		GlobalSignals.emit_signal("use_move_vector", move_vector)
	else:
		GlobalSignals.emit_signal("use_move_vector", Vector2.ZERO)
	
func calculate_move_vector(event_position):
	var texture_center = $"%TouchScreenButton".position + Vector2(115,115)
	return (event_position - texture_center).normalized()
					


func _on_TouchJump_pressed():
	if !GlobalVars.use_touch_controls:
		return
	GlobalSignals.emit_signal("touch_jump")
