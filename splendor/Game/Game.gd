extends Panel


func _ready():
	#$AudioStreamPlayer2D.play()
	pass


func reset():
	# 游戏初始设置
	
	$CardBank.reset()
	$GemBank.reset()
	$Hand.reset()
