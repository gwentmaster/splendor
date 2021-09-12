extends Panel


export (PackedScene) var Opponent


var OPPONENT_SCALE = Vector2(0.3, 0.3)


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
	
	for n in data["opponent"]:
		var container = Container.new()
		var opponent = Opponent.instance().set_name(n)
		opponent.rect_scale = OPPONENT_SCALE
		container.add_child(opponent)
		$Opponent.add_child(container)


func game_start(data: Dictionary) -> void:
	
#	$AudioStreamPlayer.play()
	var tree = get_tree()
	set_game_data(data)
	tree.call_group_flags(2, "resetable", "reset")
	tree.call_group_flags(2, "server_ui", "hide")
	tree.call_group_flags(2, "cards", "set_selectable", false)
	tree.call_group_flags(2, "gem_bank", "set_enable", "all", false)
	self.show()


func round_start() -> void:  # TODO 添加回合开始提示
	# 回合开始时, 更新购买每张卡牌的费用, 并让卡牌与宝石可以点击
	
	var tree = get_tree()
	tree.call_group("noticer", "flash")
	tree.call_group_flags(
		2,
		"cards",
		"round_start",
		$Hand.card_num, $Hand.gem_num, $Hand.gem_sum, $GemBank.gem_num["gold"]
	)
	tree.call_group_flags(2, "gem_bank", "round_start")
	$Hand/RoundMark/TextureRect.show()


func round_end() -> void:
	# 回合结束时, 让卡牌与宝石均不可点击

	var tree = get_tree()
	tree.call_group_flags(2, "cards", "set_selectable", false)
	tree.call_group_flags(2, "gem_bank", "set_enable", "all", false)
	
	if $Hand.gem_sum > 10:
		$GemSwitcher.show()
		$GemSwitcher.set_data($Hand.gem_num, $Hand.gem_sum)
	else:
		tree.call_group_flags(2, "nobility_bank", "check_price", $Hand.card_num)
		$Hand/RoundMark/TextureRect.hide()


func _on_GemSwitcher_switch_confirmed(gems: Dictionary):

	$Hand.pay_gem(gems)
	for color in gems.keys():
		if gems[color] <= 0:
			continue
		$GemBank.gain_gem(color, gems[color])
	get_tree().call_group_flags(2, "nobility_bank", "check_price", $Hand.card_num)
	$Hand/RoundMark/TextureRect.hide()
