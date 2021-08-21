extends Area2D


export var score = 0
export var color = "blue"
export var cost = {"white": 0, "blue": 0, "green": 0, "red": 0, "brown": 0}
export var reservable = true
export var buyable = true
export var selectable = true
var selected = false


var CARD_DATA = load("res://Card/CardData.gd").new()
var COST_ORDER = CARD_DATA.COST_ORDER


func _ready():
	
	$PurchaseButton.hide()
	$ReserveButton.hide()
	

func set_card(level, number):
	# 设置卡牌, 加载卡图及卡牌数据
	# Args:
	# 	level{string}: 卡牌所属分类, 在"primary", "junior", "senior"中选择
	# 	number{int}: 卡牌序号, 为负数时表示卡背
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
	
	
func set_unselected():
	if selected:
		selected = false
		$PurchaseButton.hide()
		$ReserveButton.hide()
		
		
func set_selectable(flag):
	if flag and not selectable:
		selectable = true
	elif selectable and not flag:
		selectable = false
		if selected:
			set_unselected()


func show_gold(flag):
	
	match flag:
		true:
			$ReserveButton/Gem.show()
		false:
			$ReserveButton/Gem.hide()


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
