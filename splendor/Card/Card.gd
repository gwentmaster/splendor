extends Area2D
class_name Card


export (PackedScene) var Gem


enum CardArea {DECK = 0, BANK = 1, RESERVED = 2}

export var score = 0
export var color = "blue"
export var cost = {"white": 0, "blue": 0, "green": 0, "red": 0, "brown": 0}
export var reservable = true
export var buyable = true
export var selectable = true
export var level = "primary"
export var serial_number = -2
export var area = CardArea.BANK
export var slot = 0
var selected = false
var actual_cost = {}
var with_gold = true


var GREY = Color(0.56, 0.58, 0.6)
var BLACK = Color(0, 0, 0)
var CARD_DATA = load("res://Card/CardData.gd").new()
var COST_ORDER = CARD_DATA.COST_ORDER


func _ready():
	
	$PurchaseButton.hide()
	$ReserveButton.hide()


func set_card(level: String, number: int) -> Card:
	# 设置卡牌, 加载卡图及卡牌数据
	# Args:
	# 	level: 卡牌所属分类, 在"primary", "junior", "senior"中选择
	# 	number: 卡牌序号, 为`-1`时表示卡背
	# Returns:
	# 	卡牌对象自身
	
	# number为`-1`, 表示此卡为卡背
	if number == -1:
		$CardButton/Image.texture = load("res://Assets/image/" + level + "_card/back.jpg")
		score = null
		color = null
		cost = null
		serial_number = number
		return self
	
	# 正常发展卡
	$CardButton/Image.texture = load("res://Assets/image/" + level + "_card/" + str(number) + ".jpg")
	
	var data = {
		"primary": CARD_DATA.PRIMARY_CARD_DATA,
		"junior": CARD_DATA.JUNIOR_CARD_DATA,
		"senior": CARD_DATA.SENIOR_CARD_DATA
	}[level][number]
	score = data["score"]
	color = data["color"]
	serial_number = number
	for i in range(len(COST_ORDER)):
		cost[COST_ORDER[i]] = data["cost"][i]
	
	return self
	
	
func set_unselected() -> void:
	if selected:
		selected = false
		$PurchaseButton.hide()
		$ReserveButton.hide()
		
		
func set_selectable(flag: bool) -> void:
	if flag and not selectable:
		selectable = true
	elif selectable and not flag:
		selectable = false
		if selected:
			set_unselected()
			
			
func set_reservable(flag: bool) -> void:
	$ReserveButton.set_disabled(not flag)
	match flag:
		true:
			$ReserveButton/Label.add_color_override("font_color", BLACK)
		false:
			$ReserveButton/Label.add_color_override("font_color", GREY)


func set_buyable(flag: bool) -> void:
	$PurchaseButton.set_disabled(not flag)


func show_gold(flag: bool) -> void:
	# 设置保留当前卡牌时能否获得黄金
	
	with_gold = flag
	match flag:
		true:
			$ReserveButton/Gem.show()
		false:
			$ReserveButton/Gem.hide()


func round_start(card_num: Dictionary, gem_num: Dictionary, gem_sum: int, bank_gold_num: int) -> void:
	# 回合开始时设置
	# Args:
	#     card_num: 玩家各色卡牌数, 形如{"blue": 1, "brown": 0, ...}
	#     gem_num: 玩家各色宝石数, 形如{"blue": 1, "brown": 0, "gold": 2, ...}
	#     gem_sum: 玩家宝石总数
	#     bank_gold_num: 仓库中黄金数目
	
	set_selectable(true)
	check_price(card_num, gem_num)
	
	# 玩家宝石数达10或仓库中无黄金, 则保留卡牌无法获得黄金
	if gem_sum >= 10 or bank_gold_num <= 0:
		show_gold(false)
	else:
		show_gold(true)


func check_price(card_num: Dictionary, gem_num: Dictionary) -> void:
	# 检测玩家能否购买当前卡牌
	# Args:
	#     card_num: 以卡牌颜色("blue", "brown"...)为键, 卡牌数目为值的字典
	#     gem_num: 以宝石颜色为键, 宝石数目为值的字典
	
	# 计算实际花费宝石数目
	actual_cost = {}
	var gold_demand = 0
	for color in cost.keys():
		var gem_demand = cost[color] - card_num[color]
		if gem_demand <= 0:
			continue
		if gem_demand > gem_num[color]:
			actual_cost[color] = gem_num[color]
			gold_demand += gem_demand - gem_num[color]
		else:
			actual_cost[color] = gem_demand
			
	# 清空按扭之前的内容物
	for child in $PurchaseButton.get_children():
		if child is Label:
			continue
		$PurchaseButton.remove_child(child)
		child.queue_free()
		
	# 无法购买
	if gold_demand > gem_num["gold"]:
		set_buyable(false)
		$PurchaseButton/Label.show()
		$PurchaseButton/Label.add_color_override("font_color", GREY)
	
	# 可以购买, 在购买按钮绘制需花费的宝石
	else:
		actual_cost["gold"] = gold_demand
		set_buyable(true)
		
		var total_gem_num = 0
		for v in actual_cost.values():
			total_gem_num += v
		if total_gem_num == 0:
			$PurchaseButton/Label.show()
			$PurchaseButton/Label.add_color_override("font_color", BLACK)
			return
		else:
			$PurchaseButton/Label.hide()
		
		var x = 50
		var y = 100
		var pad = 40
		for color in actual_cost.keys():
			for i in range(actual_cost[color]):
				var gem = Gem.instance().set_color(color)
				gem.scale = Vector2(0.15, 0.15)
				gem.position = Vector2(x, y)
				$PurchaseButton.add_child(gem)
				
				x += pad
				if x >= 50 + 5 * pad:
					x = 50
					y += pad


func _on_CardButton_gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		if not selectable:
			return null
		if selected == true:
			selected = false
			$PurchaseButton.hide()
			$ReserveButton.hide()
		else:
			get_tree().call_group_flags(2, "cards", "set_unselected")

			selected = true
			if buyable and area != CardArea.DECK:
				$PurchaseButton.show()
			if reservable and area != CardArea.RESERVED:
				$ReserveButton.show()


func _on_PurchaseButton_pressed() -> void:
	# 卡牌的购买按钮被点击
	
	set_unselected()
	
	# 卡牌位于仓库则需抽卡补充, 位于保留卡区则不必
	if area == CardArea.BANK:
		get_tree().call_group_flags(2, "hand", "purchase_card", actual_cost, score, color)
		get_tree().call_group("card_bank", "draw_card", level, slot)
	elif area == CardArea.RESERVED:
		get_tree().call_group_flags(2, "hand", "purchase_reserved_card", slot)
		get_tree().call_group("cards", "set_reservable", true)
	else:
		return
	
	# 花费的宝石归还仓库
	for color in actual_cost.keys():
		get_tree().call_group("gem_bank", "gain_gem", color, actual_cost[color])
	
	# 将玩家操作发给服务器并结束当前回合
	get_tree().call_group(
		"server",
		"send_json",
		{
			"command": 5,
			"data": {
				"action": "purchase_card",
				"cost": actual_cost,
				"score": score,
				"area": area,
				"slot": slot,
				"level": level,
				"color": color,
				"serial_number": serial_number
			}
		}
	)
	get_tree().call_group("game", "round_end")


func _on_ReserveButton_pressed() -> void:
	# 卡牌的保留按钮被点击
	
	set_unselected()
	var tree = get_tree()
	
	if area == CardArea.DECK:
		var num = tree.call_group_flags(2, "card_bank", level)
		tree.call_group("hand", "reserve_card", level, num, with_gold)
	elif area == CardArea.BANK:
		tree.call_group_flags(2, "hand", "reserve_card", level, serial_number, with_gold)
		tree.call_group("card_bank", "draw_card", level, slot)
	else:
		return
		
	if with_gold == true:
		tree.call_group("gem_bank", "offer_gem", "gold")
		
	# 将玩家操作发给服务器并结束当前回合
	tree.call_group(
		"server",
		"send_json",
		{
			"command": 5,
			"data": {
				"action": "reserve_card",
				"area": area,
				"slot": slot,
				"level": level,
				"serial_number": serial_number,
				"with_gold": with_gold,
			}
		}
	)
	tree.call_group_flags("game", "round_end")
