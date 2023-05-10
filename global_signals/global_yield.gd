extends Node

func yield_wait(var timeout : float, var parent = get_tree().get_root()):

	var timeoutCap = max(0, timeout / 1000.0)

	if timeoutCap <= 0:
		return

	var timer = Timer.new()
	timer.set_one_shot(true)


	# ensure that the timer object is indeed within the tree
	yield(yield_call_deferred(parent, "add_child", timer), "completed")
#	timer.start(timeoutCap)
	timer.autostart = true
	var timerRoutine = _yield_wait(timer)

	if timerRoutine.is_valid():
		yield(timerRoutine, "completed")

	yield(yield_call_deferred(parent, "remove_child", timer), "completed")

func _yield_wait(var timer : Timer):
	yield(timer, "timeout")

func yield_call_deferred(var node, var action, var parameter):
	node.call_deferred(action, parameter)
	yield(get_tree(), "idle_frame")
