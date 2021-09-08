extends Area2D
class_name Nobility


var score: int = 0
var cost: Dictionary = {"blue": 0, "brown": 0, "green": 0, "red": 0, "white": 0}
var serial_number: int = -2

var nobility_data_set = load("res://Nobility/NobilityData.gd").new()
var NOBILITY_DATA = nobility_data_set.NOBILITY_DATA
var COST_ORDER = nobility_data_set.COST_ORDER


func set_nobility(number: int) -> Nobility:
	# 设置贵族, 加载卡图及数据
	# Args:
	# 	number: 贵族序号
	# Returns:
	# 	贵族对象自身
	
	$TextureRect.texture = load("res://Assets/image/nobility/" + str(number) + ".png")
	var data = NOBILITY_DATA[number]
	serial_number = number
	score = data["score"]
	for i in range(len(COST_ORDER)):
		cost[COST_ORDER[i]] = data["cost"][i]
	return self
