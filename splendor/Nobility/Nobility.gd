extends Area2D


export var score = 0
export var cost = {"blue": 0, "brown": 0, "green": 0, "red": 0, "white": 0}

var nobility_data_set = load("res://Nobility/NobilityData.gd").new()
var NOBILITY_DATA = nobility_data_set.NOBILITY_DATA
var COST_ORDER = nobility_data_set.COST_ORDER


func set_nobility(number):
	# 设置贵族, 加载卡图及数据
	# Args:
	# 	number{int}: 贵族序号
	# Returns:
	# 	贵族对象自身
	
	$Sprite.texture = load("res://Assets/image/nobility/" + str(number) + ".jpg")
	var data = NOBILITY_DATA[number]
	score = data["score"]
	for i in range(len(COST_ORDER)):
		cost[COST_ORDER[i]] = data["cost"][i]
