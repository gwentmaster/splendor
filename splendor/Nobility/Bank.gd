extends Panel


export (PackedScene) var Nobility


func set_game_data(nobilities: Array) -> void:
	# 放置贵族卡
	# Args:
	#     nobilities: 需放置的贵族卡序号组成的列表
	
	for c in self.get_children():
		self.remove_child(c)
		c.queue_free()
	
	var x = 100
	
	for n in nobilities:
		var nob = Nobility.instance().set_nobility(n)
		nob.position = Vector2(x, 100)
		x += 250
		add_child(nob)


func check_price(card_num: Dictionary) -> void:
	# 检查当前玩家能否获得贵族卡
	# Args:
	#     card_num: 当前玩家各颜色卡牌数, 形如{"blue": 0, "brown": 3, ...}
	
	var tree = get_tree()
	var x = 100
	for nob in get_children():
		
		# 检查玩家能否获取当前贵族卡
		var buyable = true
		for c in nob.cost.keys():
			buyable = buyable and (card_num[c] >= nob.cost[c])
			if buyable == false:
				break

		# 能够获取, 将此贵族卡移出, 玩家得分, 并通知服务端
		if buyable:
			self.remove_child(nob)  # TODO 此步骤能否在get_children的循环中进行?
			tree.call_group("hand", "gain_nobility", nob.score)
			tree.call_group("server", "send_json")  # TODO
			nob.queue_free()

		# 不能获取, 调整贵族卡位置
		else:
			nob.position = Vector2(x, 100)
			x += 250


func remove_nobility(serial_number: int) -> void:
	# 移除䄶指定贵族卡
	# Args:
	#     serial_number: 需移除的贵族卡序号
	
	var x = 100
	for nob in self.get_children():
		if nob.serial_number == serial_number:
			self.remove_child(nob)  # TODO 此步骤能否在get_children的循环中进行?
			nob.queue_free()
		else:
			nob.position = Vector2(x, 100)
			x += 250


func get_game_data() -> Array:
	
	var data = []
	for nob in self.get_children():
		data.append(nob.serial_number)
	return data
