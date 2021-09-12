"""宝石返还, 若回合结束时宝石数大于10, 通过此组件将多余宝石返还仓库"""

extends Panel
class_name GemSwitcher


signal switch_confirmed (gems)


var BUTTON_SCALE = Vector2(0.4, 0.4)
var GEM_SCALE = Vector2(0.5, 0.5)


var Gem = preload("res://Gem/Gem.tscn")
var origin_gems = {"blue": 0, "brown": 0, "green": 0, "red": 0, "white": 0}
var hand_gems = {"blue": 0, "brown": 0, "green": 0, "red": 0, "white": 0}
var bank_gems = {"blue": 0, "brown": 0, "green": 0, "red": 0, "white": 0}
var bank_sum = 0
var switch_num = 0
var buttons = {}


func set_data(gems: Dictionary, gem_sum: int) -> void:
	"""根据玩家手中宝石数进行相应设置
	
	Args:
		gems: 玩家各宝石数目, 形如{"blue": 0, "brown": 1, ...}, 无"gold"
		gem_sum: 玩家宝石总数
	"""

	# 移除原有数据
	self.bank_gems = {"blue": 0, "brown": 0, "green": 0, "red": 0, "white": 0}
	self.bank_sum = 0
	self.buttons = {}
	for child in $GemContainer.get_children():
		$GemContainer.remove_child(child)
		child.queue_free()
	for child in $GemButtonContainer.get_children():
		$GemButtonContainer.remove_child(child)

	# 设置提示语
	self.origin_gems = gems
	self.switch_num = gem_sum - 10
	$Label.text = "请返还 " + str(self.switch_num) + " 颗宝石!"

	# 添加宝石按扭
	for key in ["white", "blue", "green", "red", "brown"]:
		self.hand_gems[key] = gems.get(key, 0)
		if gems.get(key, 0) <= 0:
			continue
		var button = Container.new()
		var gem = Gem.instance().set_color(key).set_label(str(gems[key]))
		gem.scale = BUTTON_SCALE
		button.add_child(gem)
		$GemButtonContainer.add_child(button)
		self.buttons[key] = button
		gem.connect("pressed", self, "_on_gem_button_pressed")


func _on_gem_button_pressed(color: String) -> void:
	"""点击宝石按钮"""

	# 若返还数目已满足要求, 则不允许再返还
	if self.bank_sum >= self.switch_num:
		return

	# 从按钮区移除1宝石, 若宝石数为0, 移除按钮
	self.hand_gems[color] -= 1
	self.buttons[color].get_child(0).set_label(str(self.hand_gems[color]))
	if self.hand_gems[color] <= 0:
		$GemButtonContainer.remove_child(self.buttons[color])
		self.buttons.erase(color)

	# 向仓库区添加1宝石
	self.bank_gems[color] += 1
	self.bank_sum += 1
	var container = Container.new()
	var gem = TextureRect.new()
	gem.texture = load("res://Assets/image/gem/" + color + ".png")
	gem.rect_scale = GEM_SCALE
	container.add_child(gem)
	$GemContainer.add_child(container)


func _on_CancelButton_pressed():
	"""点击取消按钮"""

	self.set_data(self.origin_gems, 10 + self.switch_num)


func _on_ConfirmButton_pressed():
	"""点击确认按钮"""

	self.hide()
	emit_signal("switch_confirmed", bank_gems)
