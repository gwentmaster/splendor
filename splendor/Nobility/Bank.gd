extends Panel
class_name NobilityBank


export (PackedScene) var Nobility


var NOBILITY_SCALE = Vector2(0.5, 0.5)


func set_game_data(nobilities: Array) -> void:
	# 放置贵族卡
	# Args:
	#     nobilities: 需放置的贵族卡序号组成的列表
	
	for c in $NobContainer.get_children():
		self.remove_child(c)
		c.queue_free()

	for n in nobilities:
		var container = Container.new()
		var nob = Nobility.instance().set_nobility(n)
		nob.rect_scale = NOBILITY_SCALE
		container.add_child(nob)
		$NobContainer.add_child(container)


func check_price(card_num: Dictionary) -> void:
	# 检查当前玩家能否获得贵族卡
	# Args:
	#     card_num: 当前玩家各颜色卡牌数, 形如{"blue": 0, "brown": 3, ...}
	
	var tree = get_tree()
	var buyable_nobs = []

	for container in $NobContainer.get_children():
		var nob = container.get_child(0)
		
		# 检查玩家能否获取当前贵族卡
		var buyable = true
		for c in nob.cost.keys():
			buyable = buyable and (card_num[c] >= nob.cost[c])
			if buyable == false:
				break

		# 能够获取, 记录此贵族卡
		if buyable:
			buyable_nobs.append(nob)

	# 玩家不能获取贵族卡, 直接结束回合
	if len(buyable_nobs) == 0:
		tree.call_group_flags(2, "server", "send_json", {"command": 8, "data": {}})

	# 玩家仅能获取1个贵族, 自动获取并结束回合
	elif len(buyable_nobs) == 1:
		var data = {
			"action": "get_nobility",
			"score": buyable_nobs[0].score,
			"serial_number": buyable_nobs[0].serial_number 
		}
		self.remove_nobility(buyable_nobs[0].serial_number)
		tree.call_group_flags(2, "hand", "gain_nobility", buyable_nobs[0].score)
		tree.call_group_flags(
			2,
			"server",
			"send_json",
			{
				"command": 5,
				"data": data
			}
		)
		tree.call_group("server", "send_json", {"command": 8, "data": {}})
		tree.call_group_flags(2, "log", "append_message", data)

	# 玩家能获取多个贵族, 由玩家选择1个获取
	else:
		$MultiNobNoticer.show()
		for nob in buyable_nobs:
			nob.set_selectable(true)


func remove_nobility(serial_number: int) -> void:
	# 移除䄶指定贵族卡
	# Args:
	#     serial_number: 需移除的贵族卡序号
	
	for container in $NobContainer.get_children():
		var nob = container.get_child(0)
		if nob.serial_number == serial_number:
			$NobContainer.remove_child(container)
			container.queue_free()


func set_noticer_visible(flag: bool) -> void:
	"""控制选择贵族的提示是否显示"""
	
	if flag:
		$MultiNobNoticer.show()
	else:
		$MultiNobNoticer.hide()


func get_game_data() -> Array:
	
	var data = []
	for container in $NobContainer.get_children():
		var nob = container.get_child(0)
		data.append(nob.serial_number)
	return data
