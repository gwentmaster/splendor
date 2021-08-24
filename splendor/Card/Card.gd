extends Area2D
class_name Card


export (PackedScene) var Gem


export var score = 0
export var color = "blue"
export var cost = {"white": 0, "blue": 0, "green": 0, "red": 0, "brown": 0}
export var reservable = true
export var buyable = true
export var selectable = true
export var level = "primary"
export var slot = 0
var selected = false
var actual_cost = {}


var CARD_DATA = load("res://Card/CardData.gd").new()
var COST_ORDER = CARD_DATA.COST_ORDER


func _ready():
	
	$PurchaseButton.hide()
	$ReserveButton.hide()
	
	# TODO
	cost = {"white": 1, "blue": 6, "green": 1, "red": 2, "brown": 0}
	check_price({"blue": 0, "brown": 0, "green": 0, "red": 0, "white": 0}, {"blue": 100, "brown": 100, "green": 100, "red": 100, "white": 100, "gold": 100})
	check_price({"blue": 0, "brown": 0, "green": 0, "red": 0, "white": 0}, {"blue": 5, "brown": 100, "green": 100, "red": 100, "white": 100, "gold": 100})	
	# TODO


func set_card(level: String, number: int) -> Card:
	# 设置卡牌, 加载卡图及卡牌数据
	# Args:
	# 	level: 卡牌所属分类, 在"primary", "junior", "senior"中选择
	# 	number: 卡牌序号, 为负数时表示卡背
	# Returns:
	# 	卡牌对象自身
	
	# number为负, 表示此卡为卡背
	if number < 0:
		$CardButton/Image.texture = load("res://Assets/image/" + level + "_card/back.jpg")
		score = null
		color = null
		cost = null
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
	# TODO 按扭变灰
	match flag:
		true:
			$ReserveButton
		false:
			pass
			
			
func set_buyable(flag: bool) -> void:
	$PurchaseButton.set_disabled(not flag)


func show_gold(flag: bool) -> void:
	
	match flag:
		true:
			$ReserveButton/Gem.show()
		false:
			$ReserveButton/Gem.hide()


func check_price(card_num: Dictionary, gem_num: Dictionary):
	
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
		$PurchaseButton.remove_child(child)
		child.queue_free()
		
	# 无法购买
	if gold_demand > gem_num["gold"]:
		pass
	
	# 可以购买
	else:
		actual_cost["gold"] = gold_demand
		set_buyable(true)
		
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
			if buyable:
				$PurchaseButton.show()
			if reservable:
				$ReserveButton.show()


func _on_PurchaseButton_pressed():
	set_unselected()
	get_tree().call_group("card_bank", "draw_card", level, slot)
	for color in actual_cost.keys():
		get_tree().call_group("gem_bank", "gain_gem", color, actual_cost[color])


func _on_ReserveButton_pressed():
	set_unselected()
	if reservable == false:
		return
	pass
