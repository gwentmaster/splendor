extends Panel


func _ready():
	#$AudioStreamPlayer2D.play()
	pass


func reset():
	# 游戏初始设置
	
	$CardBank.reset()
	$GemBank.reset()
	$Hand.reset()
	
	
func get_game_data() -> Dictionary:
	
	return {
		"card_bank": get_tree().call_group_flags(2, "card_bank", "get_game_data"),
		"gem_bank": get_tree().call_group_flags(2, "gem_bank", "get_game_data"),
		"hand": get_tree().call_group_flags(2, "hand", "get_game_data")
	}


func game_start() -> void:
	pass


func round_start() -> void:  # TODO 添加回合开始提示
	# 回合开始时, 让卡牌与宝石可以点击
	
	var tree = get_tree()
	tree.call_group_flags(2, "cards", "set_selectable", true)
	tree.call_group_flags(2, "gem_bank", "set_enable", "all", true)


func round_end() -> void:
	# 回合结束时, 让卡牌与宝石均不可点击

	var tree = get_tree()
	tree.call_group_flags(2, "cards", "set_selectable", false)
	tree.call_group_flags(2, "gem_bank", "set_enable", "all", false)
