extends Label
class_name Noticer


func flash(sec: float = 1) -> void:
	
	$AudioStreamPlayer.play(0.08)
	self.show()
	yield(get_tree().create_timer(sec), "timeout")
	self.hide()
