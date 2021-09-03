extends Panel
class_name GemStage


export (PackedScene) var Gem
var player_gem_num = 0


func _ready():
	self.hide()


func set_player_gem_num(num: int) -> void:
	player_gem_num = num


func add_gem(color: String) -> void:
	# 向暂存区添加1个宝石
	# Args:
	#     color: 宝石的颜色
	
	# 刚开始拿取宝石, 显示暂存区
	if self.is_visible() == false:
		self.show()

	var tree = get_tree()
	var children = $Gems.get_children()
	
	match len(children):
		0:  # 拿取了宝石, 则该回合不能购买或保留卡牌
			tree.call_group("cards", "set_selectable", false)
		1:  # 已拿取2个不同种宝石, 则不能再拿取这两种颜色的宝石
			if children[0].color != color:
				for c in [color, children[0].color]:
					tree.call_group("gem_bank", "set_enable", c, false)
		2:  # 已拿满3个宝石, 则不能再拿
			tree.call_group("gem_bank", "set_enable", "all", false)
	
	# 玩家总宝石数达10, 则不能再拿取宝石
	if len(children) + 1 + player_gem_num >= 10:
		tree.call_group("gem_bank", "set_enable", "all", false)
	
	# 调整已拿取宝石的位置, 并检查是否拿取2个同种宝石, 是则不能再拿
	var middle = (len(children) + 1) / 2
	var pad = 1 - (len(children) + 1) % 2
	for i in range(len(children)):
		children[i].position = Vector2(800 + (i + 0.5*pad - middle)*500, 450)
		if children[i].color == color:
			tree.call_group("gem_bank", "set_enable", "all", false)
	
	# 显示新拿取的宝石
	var gem = Gem.instance().set_color(color)
	gem.position = Vector2(800 + (len(children) + 0.5*pad - middle)*500, 450)
	$Gems.add_child(gem)



func _on_CancelButton_pressed():
	for child in $Gems.get_children():
		child.get_parent().remove_child(child)
		get_tree().call_group("gem_bank", "gain_gem", child.color, 1)
		child.free()
	get_tree().call_group("gem_bank", "set_enable", "all", true)
	get_tree().call_group("cards", "set_selectable", true)
	self.hide()


func _on_ConfirmButton_pressed():
	var tree = get_tree()
	var gems = {}
	for child in $Gems.get_children():
		child.get_parent().remove_child(child)
		gems[child.color] = gems.get(child.color, 0) + 1
		child.free()
	tree.call_group("hand", "gain_gem", gems)
	self.hide()
	
	# 将玩家操作发给服务器并结束当前回合
	tree.call_group(
		"server",
		"send_json",
		{
			"command": 5,
			"data": {
				"action": "get_gem",
				"gems": gems
			}
		}
	)
	tree.call_group("game", "round_end")
