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
	
	var tree = get_tree()
	return {
		"card_bank": tree.call_group_flags(2, "card_bank", "get_game_data"),
		"gem_bank": tree.call_group_flags(2, "gem_bank", "get_game_data"),
		"nobility_bank": tree.call_group_flags(2, "nobility_bank", "get_game_data"),
		"hand": tree.call_group_flags(2, "hand", "get_game_data")
	}


func set_game_data(data: Dictionary) -> void:
	
	var tree = get_tree()
	tree.call_group_flags(2, "card_bank", "set_game_data", data["card_bank"])
	tree.call_group_flags(2, "gem_bank", "set_game_data", data["gem_bank"])
	tree.call_group_flags(2, "nobility_bank", "set_game_data", data["nobility_bank"])


func game_start(data: Dictionary) -> void:
	set_game_data(data)
	get_tree().call_group_flags(2, "resetable", "reset")
	get_tree().call_group_flags(2, "server_ui", "hide")
	self.show()


func round_start() -> void:  # TODO 添加回合开始提示
	# 回合开始时, 更新购买每张卡牌的费用, 并让卡牌与宝石可以点击
	
	var tree = get_tree()
	tree.call_group_flags(
		2,
		"cards",
		"round_start",
		$Hand.card_num, $Hand.gem_num, $Hand.gem_sum, $GemBank.gem_num["gold"]
	)
	tree.call_group_flags(2, "gem_bank", "round_start", $Hand.gem_sum)


func round_end() -> void:
	# 回合结束时, 让卡牌与宝石均不可点击

	var tree = get_tree()
	tree.call_group_flags(2, "cards", "set_selectable", false)
	tree.call_group_flags(2, "gem_bank", "set_enable", "all", false)
	tree.call_group_flags(2, "server", "send_json", {"command": 8, "data": {}})
