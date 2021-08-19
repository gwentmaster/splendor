extends Area2D


export var score = 0
export var color = "blue"
export var cost = {"white": 0, "blue": 0, "green": 0, "red": 0, "brown": 0}

var CARD_DATA = load("res://Card/CardData.gd").new()
var COST_ORDER = ["white", "blue", "green", "red", "brown"]


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
