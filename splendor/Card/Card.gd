extends Area2D


export var score = 0
export var color = "blue"
export var cost = {"white": 0, "blue": 0, "green": 0, "red": 0, "brown": 0}
var choosed = false

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
		$Sprite.texture = load("res://Assets/image/" + level + "_card/back.jpg")
		score = null
		color = null
		cost = null
		return self
	
	# 正常发展卡
	$Sprite.texture = load("res://Assets/image/" + level + "_card/" + str(number) + ".jpg")
	$Sprite.scale = $Sprite.scale * self.scale
	
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


func _on_CardButton_pressed():
	# 点击卡牌时切换"购买"与"保留"两个按钮的显示状态
	
	if choosed == true:
		choosed = false
		$PurchaseButton.hide()
		$ReserveButton.hide()
	else:
		choosed = true
		$PurchaseButton.show()
		$ReserveButton.show()


func show_gold(flag):
	
	match flag:
		true:
			$ReserveButton/Gem.show()
		false:
			$ReserveButton/Gem.hide()
